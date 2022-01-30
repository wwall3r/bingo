# Initial data setup

- Created the TRIGGERS using SQL directly

  ```
  CREATE TRIGGER handle_updated_at
  		BEFORE UPDATE
  		ON public.games
  		FOR EACH ROW
  		EXECUTE FUNCTION extensions.moddatetime('updated_at');

  CREATE TRIGGER handle_updated_at
  		BEFORE UPDATE
  		ON public.tags
  		FOR EACH ROW
  		EXECUTE FUNCTION extensions.moddatetime('updated_at');
  ```

- Created the associations by having only a single type and running SELECT INTO statements

  ```
  INSERT INTO tags_objectives_assoc (tag_id, objective_id)
  SELECT a.id, b.id
  FROM tags as a, objectives as b;

  INSERT INTO games_objectives_assoc (game_id, objective_id)
  SELECT a.id, b.id
  FROM games as a, objectives as b;
  ```
