CREATE OR REPLACE FUNCTION public.create_board(
	p_game_id uuid,
	p_user_id uuid,
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
  -- Raise an error if a board exists for this user_id and game_id
  SELECT EXISTS (
    SELECT 1
    FROM games_boards gb, boards b
    WHERE gb.game_id = p_game_id
    AND gb.board_id = b.id
    AND b.user_id = auth.uid()
  ) INTO found;
  IF found THEN
     RAISE EXCEPTION 'The board already exists for the game_id and user_id';
  END IF;

  -- Insert a board
  INSERT INTO boards (user_id) VALUES (p_user_id) RETURNING id INTO board_id;

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
