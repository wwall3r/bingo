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

# Testing functions

```sql
SELECT uuid_generate_v4();
```

# Simulating a logged in user in psql

```sql
--SET request.jwt.claim.sub = 'MY USER ID';
SET request.jwt.claim.sub = 'be7dd07d-47dd-4118-b28f-9a9709a9c779';
SET ROLE authenticated;
select auth.uid();
select profile_id();
select is_member_of('408957cc-06bc-42a6-a005-4d48693ce578');

```
