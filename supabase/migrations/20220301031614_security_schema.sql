CREATE SCHEMA system
    AUTHORIZATION postgres;

CREATE TABLE IF NOT EXISTS system.user_permissions
(
    user_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    game_credit integer DEFAULT 3,
    card_credit integer DEFAULT 3,
    CONSTRAINT user_profile_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_profile_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS system.user_permissions
    OWNER to postgres;

ALTER TABLE IF EXISTS system.user_permissions
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE system.user_permissions TO postgres;

GRANT ALL ON TABLE system.user_permissions TO service_role;

COMMENT ON TABLE system.user_permissions
    IS 'A user''s permission data';
