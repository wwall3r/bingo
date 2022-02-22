CREATE OR REPLACE FUNCTION public.get_user_games() RETURNS uuid[] AS
$BODY$
  SELECT ARRAY(
    SELECT gu.game_id
    FROM games_users gu
    WHERE gu.profile_id = profile_id()
  );
$BODY$ LANGUAGE sql SECURITY DEFINER;

ALTER FUNCTION public.get_user_games()
  OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.get_user_games() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.get_user_games() TO anon;

GRANT EXECUTE ON FUNCTION public.get_user_games() TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_user_games() TO postgres;

GRANT EXECUTE ON FUNCTION public.get_user_games() TO service_role;


CREATE OR REPLACE FUNCTION public.is_member_of(_game_id uuid) RETURNS bool AS
$BODY$
  SELECT _game_id = any(get_user_games());
$BODY$ LANGUAGE sql SECURITY DEFINER;

