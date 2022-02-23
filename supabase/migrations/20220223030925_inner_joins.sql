-- FUNCTION: public.create_board(uuid, uuid, integer)

-- DROP FUNCTION IF EXISTS public.create_board(uuid, uuid, integer);

CREATE OR REPLACE FUNCTION public.create_board(
	p_game_id uuid,
	p_profile_id uuid,
	p_num_objectives integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
declare
   found boolean;
   board_id uuid;
   completion_id uuid;
   temprow games_objectives%ROWTYPE;

BEGIN
  -- Raise an error if a board exists for this profile_id and game_id
  SELECT EXISTS (
    SELECT 1
    FROM games_boards gb
	INNER JOIN boards AS b ON gb.board_id = b.id
    WHERE gb.game_id = p_game_id
    AND b.profile_id = profile_id()
  ) INTO found;
  IF found THEN
     RAISE EXCEPTION 'The board already exists for the game_id and profile_id'; 
  END IF;

  -- Insert a board
  INSERT INTO boards (profile_id) VALUES (p_profile_id) RETURNING id INTO board_id;

  -- Insert an association from the board to the game
  INSERT INTO games_boards (game_id, board_id) VALUES (p_game_id, board_id);
   
  -- Insert completions
  -- Insert an association from the board to the completion
  -- TODO: There is a possibility of an underrun on p_num_objectives
  FOR temprow IN
    SELECT * FROM games_objectives WHERE game_id=p_game_id ORDER BY RANDOM() LIMIT p_num_objectives
      LOOP
        INSERT INTO completions (objective_id) VALUES (temprow.objective_id) RETURNING id INTO completion_id;
        INSERT INTO boards_completions(board_id, completion_id) VALUES (board_id, completion_id);
      END LOOP;
END;
$BODY$;

ALTER FUNCTION public.create_board(uuid, uuid, integer)
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.create_board(uuid, uuid, integer) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.create_board(uuid, uuid, integer) TO anon;

GRANT EXECUTE ON FUNCTION public.create_board(uuid, uuid, integer) TO authenticated;

GRANT EXECUTE ON FUNCTION public.create_board(uuid, uuid, integer) TO postgres;

GRANT EXECUTE ON FUNCTION public.create_board(uuid, uuid, integer) TO service_role;


CREATE OR REPLACE FUNCTION public.get_completions_for_user()
    RETURNS TABLE (board_id uuid, game_id uuid, profile_id uuid, completion_id uuid) AS
$BODY$
    SELECT
        gb.board_id,
        gb.game_id,
        b.profile_id,
        bc.completion_id
    FROM
        games_boards AS gb
    INNER JOIN boards AS b ON gb.board_id = b.id
    INNER JOIN boards_completions AS bc ON gb.board_id = bc.board_id
    INNER JOIN completions AS c ON bc.completion_id = c.id
    WHERE
        gb.game_id = any(get_user_games())
$BODY$ LANGUAGE sql SECURITY DEFINER;

ALTER FUNCTION public.get_completions_for_user()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO anon;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO postgres;

GRANT EXECUTE ON FUNCTION public.get_completions_for_user() TO service_role;
