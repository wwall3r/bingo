-- This script was generated by the Schema Diff utility in pgAdmin 4
-- For the circular dependencies, the order in which Schema Diff writes the objects is not very sophisticated
-- and may require manual changes to the script to ensure changes are applied in the correct order.
-- Please report an issue for any failure with the reproduction steps.

create extension if not exists moddatetime schema extensions;

CREATE TABLE IF NOT EXISTS public.user_profiles
(
    id uuid references auth.users NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    display_name character varying COLLATE pg_catalog."default",
    CONSTRAINT user_profile_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.user_profiles
    OWNER to postgres;

ALTER TABLE IF EXISTS public.user_profiles
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.user_profiles TO anon;

GRANT ALL ON TABLE public.user_profiles TO authenticated;

GRANT ALL ON TABLE public.user_profiles TO postgres;

GRANT ALL ON TABLE public.user_profiles TO service_role;

COMMENT ON TABLE public.user_profiles
    IS 'A user''s public data';

CREATE OR REPLACE FUNCTION public.create_user_profile()
    RETURNS trigger
AS $BODY$
begin
  INSERT INTO public.user_profiles (id, display_name, role_id)
  VALUES (NEW.id, 'New User', (SELECT ID from public.roles WHERE label='player'));
  RETURN NEW;
end;
$BODY$ LANGUAGE plpgsql SECURITY DEFINER;




ALTER FUNCTION public.create_user_profile()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.create_user_profile() TO authenticated;

GRANT EXECUTE ON FUNCTION public.create_user_profile() TO postgres;

GRANT EXECUTE ON FUNCTION public.create_user_profile() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.create_user_profile() TO anon;

GRANT EXECUTE ON FUNCTION public.create_user_profile() TO service_role;

CREATE TRIGGER
    create_profile_on_signup
    AFTER INSERT ON auth.users
    FOR EACH ROW
        EXECUTE PROCEDURE public.create_user_profile();

CREATE TABLE IF NOT EXISTS public.cards
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    user_id uuid NOT NULL,
    CONSTRAINT card_pkey PRIMARY KEY (id),
    CONSTRAINT cards_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.user_profiles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cards
    OWNER to postgres;

ALTER TABLE IF EXISTS public.cards
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.cards TO authenticated;

GRANT ALL ON TABLE public.cards TO anon;

GRANT ALL ON TABLE public.cards TO service_role;

GRANT ALL ON TABLE public.cards TO postgres;

COMMENT ON TABLE public.cards
    IS 'An instance of a game';


CREATE TABLE IF NOT EXISTS public.objectives
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    label character varying COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT objectives_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.objectives
    OWNER to postgres;

ALTER TABLE IF EXISTS public.objectives
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.objectives TO anon;

GRANT ALL ON TABLE public.objectives TO authenticated;

GRANT ALL ON TABLE public.objectives TO postgres;

GRANT ALL ON TABLE public.objectives TO service_role;

COMMENT ON TABLE public.objectives
    IS 'A single item to be used on a card';

CREATE TRIGGER handle_updated_at
    BEFORE UPDATE
    ON public.objectives
    FOR EACH ROW
    EXECUTE FUNCTION extensions.moddatetime('updated_at');



CREATE TABLE IF NOT EXISTS public.completions
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    objective_id uuid NOT NULL,
    state character varying COLLATE pg_catalog."default" NOT NULL DEFAULT '''incomplete'''::character varying,
    notes text COLLATE pg_catalog."default",
    CONSTRAINT completions_pkey PRIMARY KEY (id),
    CONSTRAINT completions_objective_id_fkey FOREIGN KEY (objective_id)
        REFERENCES public.objectives (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.completions
    OWNER to postgres;

ALTER TABLE IF EXISTS public.completions
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.completions TO anon;

GRANT ALL ON TABLE public.completions TO authenticated;

GRANT ALL ON TABLE public.completions TO postgres;

GRANT ALL ON TABLE public.completions TO service_role;


CREATE TABLE IF NOT EXISTS public.cards_completions
(
    card_id uuid NOT NULL,
    completion_id uuid NOT NULL,
    CONSTRAINT cards_completions_pkey PRIMARY KEY (card_id, completion_id),
    CONSTRAINT cards_completions_card_id_fkey FOREIGN KEY (card_id)
        REFERENCES public.cards (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT cards_completions_completion_id_fkey FOREIGN KEY (completion_id)
        REFERENCES public.completions (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.cards_completions
    OWNER to postgres;

GRANT ALL ON TABLE public.cards_completions TO authenticated;

GRANT ALL ON TABLE public.cards_completions TO anon;

GRANT ALL ON TABLE public.cards_completions TO service_role;

GRANT ALL ON TABLE public.cards_completions TO postgres;

COMMENT ON TABLE public.cards_completions
    IS 'The association of cards to completions';


COMMENT ON TABLE public.completions
    IS 'The state of the objectives for a card';



CREATE TABLE IF NOT EXISTS public.games
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    label character varying COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    card_size smallint NOT NULL DEFAULT '5'::smallint,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '90 days'::interval),
    CONSTRAINT games_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.games
    OWNER to postgres;

ALTER TABLE IF EXISTS public.games
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.games TO anon;

GRANT ALL ON TABLE public.games TO authenticated;

GRANT ALL ON TABLE public.games TO postgres;

GRANT ALL ON TABLE public.games TO service_role;

COMMENT ON TABLE public.games
    IS 'The game instances';

CREATE TRIGGER handle_updated_at
    BEFORE UPDATE
    ON public.games
    FOR EACH ROW
    EXECUTE FUNCTION extensions.moddatetime('updated_at');



CREATE TABLE IF NOT EXISTS public.games_objectives
(
    game_id uuid NOT NULL,
    objective_id uuid NOT NULL,
    CONSTRAINT game_objective_assoc_pkey PRIMARY KEY (game_id, objective_id),
    CONSTRAINT game_objective_assoc_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.games (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT game_objective_assoc_objective_id_fkey FOREIGN KEY (objective_id)
        REFERENCES public.objectives (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.games_objectives
    OWNER to postgres;

ALTER TABLE IF EXISTS public.games_objectives
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.games_objectives TO authenticated;

GRANT ALL ON TABLE public.games_objectives TO anon;

GRANT ALL ON TABLE public.games_objectives TO service_role;

GRANT ALL ON TABLE public.games_objectives TO postgres;

COMMENT ON TABLE public.games_objectives
    IS 'Associates games to objectives';

CREATE TABLE IF NOT EXISTS public.games_users
(
    game_id uuid NOT NULL,
    user_id uuid,
    CONSTRAINT games_users_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.games (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT games_users_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.user_profiles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.games_users
    OWNER to postgres;

ALTER TABLE IF EXISTS public.games_users
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.games_users TO anon;

GRANT ALL ON TABLE public.games_users TO authenticated;

GRANT ALL ON TABLE public.games_users TO postgres;

GRANT ALL ON TABLE public.games_users TO service_role;

COMMENT ON TABLE public.games_users
    IS 'The audience of game. Those that are able to create or view cards. ';

CREATE TABLE IF NOT EXISTS public.games_cards
(
    game_id uuid NOT NULL,
    card_id uuid NOT NULL,
    CONSTRAINT games_cards_pkey PRIMARY KEY (game_id, card_id),
    CONSTRAINT games_cards_card_id_fkey FOREIGN KEY (card_id)
        REFERENCES public.cards (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT games_cards_game_id_fkey FOREIGN KEY (game_id)
        REFERENCES public.games (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.games_cards
    OWNER to postgres;

ALTER TABLE IF EXISTS public.games_cards
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.games_cards TO authenticated;

GRANT ALL ON TABLE public.games_cards TO anon;

GRANT ALL ON TABLE public.games_cards TO service_role;

GRANT ALL ON TABLE public.games_cards TO postgres;

COMMENT ON TABLE public.games_cards
    IS 'One game can have multiple card instances';

CREATE TABLE IF NOT EXISTS public.tags
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    label character varying COLLATE pg_catalog."default" NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT tags_pkey PRIMARY KEY (id),
    CONSTRAINT tags_label_key UNIQUE (label)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tags
    OWNER to postgres;

ALTER TABLE IF EXISTS public.tags
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.tags TO anon;

GRANT ALL ON TABLE public.tags TO authenticated;

GRANT ALL ON TABLE public.tags TO postgres;

GRANT ALL ON TABLE public.tags TO service_role;

COMMENT ON TABLE public.tags
    IS 'Provides a means for categorizing Objectives';
CREATE TRIGGER handle_updated_at
    BEFORE UPDATE
    ON public.tags
    FOR EACH ROW
    EXECUTE FUNCTION extensions.moddatetime('updated_at');


CREATE TABLE IF NOT EXISTS public.tags_objectives
(
    tag_id uuid NOT NULL,
    objective_id uuid NOT NULL,
    CONSTRAINT tags_objectives_assoc_pkey PRIMARY KEY (tag_id, objective_id),
    CONSTRAINT tags_objectives_assoc_objective_id_fkey FOREIGN KEY (objective_id)
        REFERENCES public.objectives (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tags_objectives_assoc_tag_id_fkey FOREIGN KEY (tag_id)
        REFERENCES public.tags (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tags_objectives
    OWNER to postgres;

ALTER TABLE IF EXISTS public.tags_objectives
    ENABLE ROW LEVEL SECURITY;

GRANT ALL ON TABLE public.tags_objectives TO authenticated;

GRANT ALL ON TABLE public.tags_objectives TO anon;

GRANT ALL ON TABLE public.tags_objectives TO service_role;

GRANT ALL ON TABLE public.tags_objectives TO postgres;

COMMENT ON TABLE public.tags_objectives
    IS 'Associates a tag to an objective';


CREATE OR REPLACE FUNCTION public.is_member_of(
	_game_id uuid)
    RETURNS boolean
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
SELECT EXISTS (
  SELECT 1
  FROM games_users gu
  WHERE gu.game_id = _game_id
  AND gu.user_id = auth.uid()
);
$BODY$;

-- FUNCTIIONS
ALTER FUNCTION public.is_member_of(uuid)
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.is_member_of(uuid) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.is_member_of(uuid) TO anon;

GRANT EXECUTE ON FUNCTION public.is_member_of(uuid) TO authenticated;

GRANT EXECUTE ON FUNCTION public.is_member_of(uuid) TO postgres;

GRANT EXECUTE ON FUNCTION public.is_member_of(uuid) TO service_role;

-- POLICY
CREATE POLICY "Enable ALL for users based on user_id"
    ON public.cards
    AS PERMISSIVE
    FOR ALL
    TO public
    USING ((auth.uid() = user_id))
    WITH CHECK ((auth.uid() = user_id));

CREATE POLICY "completions - owners can execute ALL "
    ON public.completions
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((EXISTS ( SELECT 1
   FROM completions c,
    cards b,
    cards_completions bc
  WHERE ((c.id = bc.completion_id) AND (b.id = bc.card_id) AND (auth.uid() = b.user_id)))));

CREATE POLICY "game members can read"
    ON public.games
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING (is_member_of(id));

CREATE POLICY "game members can read"
    ON public.games_cards
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING (is_member_of(game_id));

CREATE POLICY "game members can read"
    ON public.games_objectives
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING (is_member_of(game_id));

CREATE POLICY "game members can read"
    ON public.games_users
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING (is_member_of(game_id));

CREATE POLICY "Enable insert for authenticated users only"
    ON public.objectives
    AS PERMISSIVE
    FOR INSERT
    TO public
    WITH CHECK ((auth.role() = 'authenticated'::text));

CREATE POLICY "Enable update for authenticated users only"
    ON public.objectives
    AS PERMISSIVE
    FOR UPDATE
    TO public
    WITH CHECK ((auth.role() = 'authenticated'::text));
CREATE POLICY "objectives - authenticated users can read"
    ON public.objectives
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((auth.role() = 'authenticated'::text));

CREATE POLICY "tags - authenticated users can read"
    ON public.tags
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((auth.role() = 'authenticated'::text));

CREATE POLICY "Enable all actions for users based on user_id"
    ON public.user_profiles
    AS PERMISSIVE
    FOR ALL
    TO public
    USING ((auth.uid() = id))
    WITH CHECK ((auth.uid() = id));

CREATE POLICY "Enable insert for authenticated users only"
    ON public.user_profiles
    AS PERMISSIVE
    FOR SELECT
    TO public
    USING ((auth.role() = 'authenticated'::text));



