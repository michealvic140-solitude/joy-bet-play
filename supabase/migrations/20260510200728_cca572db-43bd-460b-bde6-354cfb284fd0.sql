
DO $$
DECLARE
  r record;
BEGIN
  FOR r IN
    SELECT conname, conrelid::regclass::text AS tbl
    FROM pg_constraint
    WHERE conname IN (
      'support_tickets_user_id_fkey','ticket_messages_user_id_fkey',
      'bets_user_id_fkey','promo_code_requests_user_id_fkey',
      'withdrawal_requests_user_id_fkey','user_tasks_user_id_fkey',
      'user_achievements_user_id_fkey','ban_appeals_user_id_fkey',
      'notifications_user_id_fkey','chat_messages_user_id_fkey',
      'token_requests_user_id_fkey','token_transactions_user_id_fkey',
      'promo_redemptions_user_id_fkey','user_roles_user_id_fkey'
    )
  LOOP
    EXECUTE format('ALTER TABLE %s DROP CONSTRAINT %I', r.tbl, r.conname);
  END LOOP;
END $$;

ALTER TABLE public.support_tickets   ADD CONSTRAINT support_tickets_user_id_fkey   FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.ticket_messages   ADD CONSTRAINT ticket_messages_user_id_fkey   FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.bets              ADD CONSTRAINT bets_user_id_fkey              FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.promo_code_requests ADD CONSTRAINT promo_code_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.withdrawal_requests ADD CONSTRAINT withdrawal_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.user_tasks        ADD CONSTRAINT user_tasks_user_id_fkey        FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.user_achievements ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.ban_appeals       ADD CONSTRAINT ban_appeals_user_id_fkey       FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.notifications     ADD CONSTRAINT notifications_user_id_fkey     FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.chat_messages     ADD CONSTRAINT chat_messages_user_id_fkey     FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.token_requests    ADD CONSTRAINT token_requests_user_id_fkey    FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.token_transactions ADD CONSTRAINT token_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.promo_redemptions ADD CONSTRAINT promo_redemptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
ALTER TABLE public.user_roles        ADD CONSTRAINT user_roles_user_id_fkey        FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

NOTIFY pgrst, 'reload schema';
