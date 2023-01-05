CREATE OR REPLACE FUNCTION public.can_write_completions(p_user_id uuid) RETURNS bool AS
$BODY$
SELECT p_user_id IN (
    SELECT b.user_id
    FROM completions c,
        cards b,
        cards_completions bc
    WHERE c.id = bc.completion_id
        AND b.id = bc.card_id
);
$BODY$ LANGUAGE sql SECURITY DEFINER;

ALTER FUNCTION public.can_write_completions(uuid)
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.can_write_completions(uuid) TO postgres;

GRANT EXECUTE ON FUNCTION public.can_write_completions(uuid) TO service_role;

