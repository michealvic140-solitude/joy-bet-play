
ALTER TABLE public.promo_codes
  ADD COLUMN IF NOT EXISTS max_uses integer,
  ADD COLUMN IF NOT EXISTS target_user_ids uuid[];

DROP VIEW IF EXISTS public.promo_code_usage_log;
CREATE VIEW public.promo_code_usage_log
WITH (security_invoker = true) AS
SELECT
  pc.id                  AS promo_id,
  pc.code                AS code,
  pc.amount              AS amount,
  pc.usage_limit         AS usage_limit,
  pc.max_uses            AS max_uses,
  pc.target_user_ids     AS target_user_ids,
  pc.used_count          AS used_count,
  pc.is_active           AS is_active,
  pc.expires_at          AS expires_at,
  pc.created_at          AS generated_at,
  pc.created_by          AS created_by,
  creator.full_name      AS generated_by_name,
  creator.email          AS generated_by_email,
  pr.id                  AS redemption_id,
  pr.user_id             AS used_by,
  pr.created_at          AS used_at,
  user_p.full_name       AS used_by_name,
  user_p.email           AS used_by_email,
  user_p.gang_name       AS used_by_gang_name
FROM public.promo_codes pc
LEFT JOIN public.profiles creator ON creator.id = pc.created_by
LEFT JOIN public.promo_redemptions pr ON pr.promo_id = pc.id
LEFT JOIN public.profiles user_p ON user_p.id = pr.user_id;
