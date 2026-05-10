
-- 1) Auth signup trigger (was missing — root cause of empty profiles/roles)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 2) Backfill any auth user that has no profile (e.g. signups created before trigger existed)
INSERT INTO public.profiles (id, full_name, email, phone, discord_username, discord_full_name, ingame_name, country, server, gang_name, gang_type)
SELECT
  u.id,
  COALESCE(u.raw_user_meta_data->>'full_name', split_part(u.email,'@',1)),
  u.email,
  u.raw_user_meta_data->>'phone',
  u.raw_user_meta_data->>'discord_username',
  u.raw_user_meta_data->>'discord_full_name',
  u.raw_user_meta_data->>'ingame_name',
  u.raw_user_meta_data->>'country',
  COALESCE(u.raw_user_meta_data->>'server','LOMITA AFR'),
  u.raw_user_meta_data->>'gang_name',
  NULLIF(u.raw_user_meta_data->>'gang_type','')::public.gang_type
FROM auth.users u
LEFT JOIN public.profiles p ON p.id = u.id
WHERE p.id IS NULL;

INSERT INTO public.user_roles (user_id, role)
SELECT u.id, CASE WHEN u.email = 'lomitashootersleague@gmail.com' THEN 'admin'::public.app_role ELSE 'viewer'::public.app_role END
FROM auth.users u
LEFT JOIN public.user_roles r ON r.user_id = u.id
WHERE r.user_id IS NULL;

-- 3) Notify ticket owner when an admin/mod replies on their ticket
CREATE OR REPLACE FUNCTION public.notify_ticket_reply()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE owner uuid;
BEGIN
  SELECT user_id INTO owner FROM public.support_tickets WHERE id = NEW.ticket_id;
  IF owner IS NULL OR NEW.user_id = owner THEN
    RETURN NEW;
  END IF;
  INSERT INTO public.notifications(user_id, title, body, link)
  VALUES (owner, 'New reply on your support ticket',
          COALESCE(LEFT(NEW.content, 140), 'Admin sent you a reply.'),
          '/ticket/' || NEW.ticket_id);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_notify_ticket_reply ON public.ticket_messages;
CREATE TRIGGER trg_notify_ticket_reply
AFTER INSERT ON public.ticket_messages
FOR EACH ROW EXECUTE FUNCTION public.notify_ticket_reply();
