CREATE OR REPLACE FUNCTION public.get_completions_for_user()
    RETURNS TABLE (board_id uuid, game_id uuid, user_id uuid, completion_id uuid) AS
$BODY$
    SELECT
        gb.board_id,
        gb.game_id,
        b.user_id,
        bc.completion_id
    FROM
        games_boards gb,
        boards b,
        boards_completions bc,
        completions c
    WHERE
        gb.game_id = any(get_user_games()) AND
        b.id = gb.board_id AND
        bc.board_id = gb.board_id AND
        c.id = bc.completion_id;
    -- TODO: Jason, I saw you use something like this and was curious
    -- how it differed (or not) in plan from a more structured join syntax
$BODY$ LANGUAGE sql SECURITY DEFINER;

ALTER FUNCTION public.get_completions_for_user()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO anon;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO postgres;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO service_role;
