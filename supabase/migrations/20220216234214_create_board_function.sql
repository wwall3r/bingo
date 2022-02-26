-- This script was generated by the Schema Diff utility in pgAdmin 4
-- For the circular dependencies, the order in which Schema Diff writes the objects is not very sophisticated
-- and may require manual changes to the script to ensure changes are applied in the correct order.
-- Please report an issue for any failure with the reproduction steps.

CREATE OR REPLACE FUNCTION public.create_board(
	p_game_id uuid,
	p_profile_id uuid,
	p_num_objectives integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
   board_id uuid;
   completion_id uuid;
   temprow games_objectives%ROWTYPE;
BEGIN
   -- Insert a board
   board_id := uuid_generate_v4();
   INSERT INTO boards (id, profile_id) VALUES (board_id, p_profile_id);

   -- Insert an association from the board to the game
   INSERT INTO games_boards (game_id, board_id) VALUES (p_game_id, board_id);
   
   -- Insert completions
   -- Insert an association from the board to the completion
   -- TODO: There is a possibility of an underrun on p_num_objectives
   FOR temprow IN
        SELECT * FROM games_objectives WHERE game_id=p_game_id ORDER BY RANDOM() LIMIT p_num_objectives
      LOOP
        completion_id := uuid_generate_v4();
        INSERT INTO completions (id, objective_id) VALUES (completion_id, temprow.objective_id);
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