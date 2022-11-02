CREATE OR REPLACE FUNCTION public.can_write_completions(p_user_id uuid) RETURNS bool AS
$BODY$
SELECT p_user_id IN (
    SELECT b.user_id
    FROM completions c,
        boards b,
        boards_completions bc
    WHERE c.id = bc.completion_id
        AND b.id = bc.board_id
);
$BODY$ LANGUAGE sql SECURITY DEFINER;

ALTER FUNCTION public.can_write_completions(uuid)
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.can_write_completions(uuid) TO postgres;

GRANT EXECUTE ON FUNCTION public.can_write_completions(uuid) TO service_role;

