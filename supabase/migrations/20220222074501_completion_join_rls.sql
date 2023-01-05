CREATE OR REPLACE FUNCTION public.get_completions_for_user()
    RETURNS TABLE (card_id uuid, game_id uuid, user_id uuid, completion_id uuid) AS
$BODY$
    SELECT
        gb.card_id,
        gb.game_id,
        b.user_id,
        bc.completion_id
    FROM
        games_cards gb,
        cards b,
        cards_completions bc,
        completions c
    WHERE
        gb.game_id = any(get_user_games()) AND
        b.id = gb.card_id AND
        bc.card_id = gb.card_id AND
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
