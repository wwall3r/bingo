CREATE TABLE IF NOT EXISTS public.completion_states
(
    id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    label character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT completion_states_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.completion_states
    OWNER to postgres;

GRANT ALL ON TABLE public.completion_states TO anon;

GRANT ALL ON TABLE public.completion_states TO authenticated;

GRANT ALL ON TABLE public.completion_states TO postgres;

GRANT ALL ON TABLE public.completion_states TO service_role;

COMMENT ON TABLE public.completion_states
    IS 'The states allowed for completions';

ALTER TABLE public.completions
    DROP COLUMN state;
ALTER TABLE public.completions
    ADD COLUMN state integer;
ALTER TABLE IF EXISTS public.completions
    ALTER COLUMN state SET DEFAULT 1;

ALTER TABLE IF EXISTS public.completions
    ADD CONSTRAINT completions_state_fkey FOREIGN KEY (state)
    REFERENCES public.completion_states (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
