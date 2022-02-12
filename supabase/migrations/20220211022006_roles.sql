CREATE TABLE IF NOT EXISTS public.roles
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp with time zone DEFAULT now(),
    label character varying COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT roles_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.roles
    OWNER to postgres;

ALTER TABLE IF EXISTS public.roles
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.roles TO anon;

GRANT ALL ON TABLE public.roles TO authenticated;

GRANT ALL ON TABLE public.roles TO postgres;

GRANT ALL ON TABLE public.roles TO service_role;

COMMENT ON TABLE public.roles
    IS 'Roles and descriptions';
CREATE POLICY "Enable read for authenticated users only"
    ON public.roles
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((auth.role() = 'authenticated'::text));



CREATE OR REPLACE FUNCTION public.default_game_role()
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
   role_id roles.id%type;
begin
  select id
  into role_id
  from roles
  where "label" = 'player';
  if not found then
     raise 'role with label=player not found';
  end if;
  return role_id;
end;
$BODY$;

ALTER FUNCTION public.default_game_role()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.default_game_role() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.default_game_role() TO anon;

GRANT EXECUTE ON FUNCTION public.default_game_role() TO authenticated;

GRANT EXECUTE ON FUNCTION public.default_game_role() TO postgres;

GRANT EXECUTE ON FUNCTION public.default_game_role() TO service_role;


CREATE OR REPLACE FUNCTION public.default_system_role(
        )
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
   role_id roles.id%type;
begin
  select id
  into role_id
  from roles
  where "label" = 'viewer';
  if not found then
     raise 'role with label=viewer not found';
  end if;
  return role_id;
end;
$BODY$;

ALTER FUNCTION public.default_system_role()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.default_system_role() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.default_system_role() TO anon;

GRANT EXECUTE ON FUNCTION public.default_system_role() TO authenticated;

GRANT EXECUTE ON FUNCTION public.default_system_role() TO postgres;

GRANT EXECUTE ON FUNCTION public.default_system_role() TO service_role;


ALTER TABLE IF EXISTS public.games_users
    ADD COLUMN role_id uuid NOT NULL DEFAULT default_game_role();

COMMENT ON COLUMN public.games_users.role_id
    IS 'user''s role for the game';

ALTER TABLE IF EXISTS public.games_users
    ADD CONSTRAINT games_users_role_id_fkey FOREIGN KEY (role_id)
    REFERENCES public.roles (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.user_profiles
    ADD COLUMN role_id uuid NOT NULL DEFAULT default_system_role();

COMMENT ON COLUMN public.user_profiles.role_id
    IS 'The system role assigned to the profile';