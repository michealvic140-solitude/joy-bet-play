COMMENT ON TABLE public.support_tickets IS 'User-submitted support reports';
COMMENT ON CONSTRAINT support_tickets_user_id_fkey ON public.support_tickets IS 'Owner profile';
NOTIFY pgrst, 'reload schema';
NOTIFY pgrst, 'reload config';