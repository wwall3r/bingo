-- FUNCTION: public.create_card(uuid, uuid, integer)

-- DROP FUNCTION IF EXISTS public.create_card(uuid, uuid, integer);

CREATE OR REPLACE FUNCTION public.create_card(
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
   card_id uuid;
   completion_id uuid;
   temprow games_objectives%ROWTYPE;

BEGIN
  -- Raise an error if a card exists for this user_id and game_id
  SELECT EXISTS (
    SELECT 1
    FROM games_cards gb
	INNER JOIN cards AS b ON gb.card_id = b.id
    WHERE gb.game_id = p_game_id
    AND b.user_id = auth.uid()
  ) INTO found;
  IF found THEN
     RAISE EXCEPTION 'The card already exists for the game_id and user_id';
  END IF;

  -- Insert a card
  INSERT INTO cards (user_id) VALUES (p_user_id) RETURNING id INTO card_id;

  -- Insert an association from the card to the game
  INSERT INTO games_cards (game_id, card_id) VALUES (p_game_id, card_id);

  -- Insert completions
  -- Insert an association from the card to the completion
  -- TODO: There is a possibility of an underrun on p_num_objectives
  FOR temprow IN
    SELECT * FROM games_objectives WHERE game_id=p_game_id ORDER BY RANDOM() LIMIT p_num_objectives
      LOOP
        INSERT INTO completions (objective_id) VALUES (temprow.objective_id) RETURNING id INTO completion_id;
        INSERT INTO cards_completions(card_id, completion_id) VALUES (card_id, completion_id);
      END LOOP;
END;
$BODY$;

ALTER FUNCTION public.create_card(uuid, uuid, integer)
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.create_card(uuid, uuid, integer) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.create_card(uuid, uuid, integer) TO anon;

GRANT EXECUTE ON FUNCTION public.create_card(uuid, uuid, integer) TO authenticated;

GRANT EXECUTE ON FUNCTION public.create_card(uuid, uuid, integer) TO postgres;

GRANT EXECUTE ON FUNCTION public.create_card(uuid, uuid, integer) TO service_role;


CREATE OR REPLACE FUNCTION public.get_completions_for_user()
    RETURNS TABLE (card_id uuid, game_id uuid, user_id uuid, completion_id uuid) AS
$BODY$
    SELECT
        gb.card_id,
        gb.game_id,
        b.user_id,
        bc.completion_id
    FROM
        games_cards AS gb
    INNER JOIN cards AS b ON gb.card_id = b.id
    INNER JOIN cards_completions AS bc ON gb.card_id = bc.card_id
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
