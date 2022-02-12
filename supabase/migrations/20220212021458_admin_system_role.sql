CREATE OR REPLACE FUNCTION public.system_role_id()
 RETURNS uuid
 LANGUAGE 'plpgsql'
 COST 100 VOLATILE PARALLEL UNSAFE
AS $BODY$ 
  declare role_id user_profiles.role_id % TYPE;
BEGIN
  SELECT
    id INTO role_id
  FROM
    user_profiles
  WHERE
    user_id = auth.uid();
  IF NOT found THEN 
    raise 'profile with user_id % not found', auth.uid();
  END IF;
  RETURN role_id;
END;
$BODY$;

ALTER FUNCTION public.system_role_id() OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.system_role_id() TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.system_role_id() TO anon;

GRANT EXECUTE ON FUNCTION public.system_role_id() TO authenticated;

GRANT EXECUTE ON FUNCTION public.system_role_id() TO postgres;

GRANT EXECUTE ON FUNCTION public.system_role_id() TO service_role;


ALTER TABLE IF EXISTS public.boards_completions
    ENABLE ROW LEVEL SECURITY;


CREATE POLICY "enabled all for admin" ON public.games AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN ( SELECT id FROM roles WHERE label = 'admin' ) )
) WITH CHECK (
  system_role_id() IN ( SELECT id FROM roles WHERE label = 'admin' )
);

CREATE POLICY "admin all" ON public.boards AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.completions AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.games AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.objectives AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.tags AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.user_profiles AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.boards_completions AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.games_boards AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.games_objectives AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.games_users AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);

CREATE POLICY "admin all" ON public.tags_objectives AS PERMISSIVE FOR ALL TO public USING (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
) WITH CHECK (
  ( system_role_id() IN (SELECT id FROM roles WHERE label = 'admin') )
);
