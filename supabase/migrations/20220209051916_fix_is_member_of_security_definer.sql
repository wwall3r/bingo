CREATE OR REPLACE FUNCTION public.is_member_of(_game_id uuid) RETURNS bool AS
$BODY$
SELECT EXISTS (
  SELECT 1
  FROM games_users gu
  WHERE gu.game_id = _game_id
  AND gu.user_id = auth.uid()
);
$BODY$ LANGUAGE sql SECURITY DEFINER;
