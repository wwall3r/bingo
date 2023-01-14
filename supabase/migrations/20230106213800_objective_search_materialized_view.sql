-- drop materialized view if exists public.objective_search_terms ;

create materialized view public.objective_search_terms
as
select
	o.id,
	to_tsvector(concat_ws(' ', o.label, o.description, tags.label, op.label, op.description, up.display_name)) as tsv
from
	objectives as o
left join tags_objectives tob on
	tob.objective_id = o.id
left join tags on
	tags.id = tob.tag_id
left join objectives_objective_packs oop on
	oop.objective_id = o.id
left join objective_packs op on
	op.id = oop.objective_pack_id
left join user_profiles up on
	up.id = op.user_id 
;
COMMENT ON MATERIALIZED VIEW public.objective_search_terms
    IS 'Fuzzy Search for objectives';


CREATE OR REPLACE FUNCTION public.refresh_objective_search_terms()
    RETURNS trigger
AS $BODY$
begin
  REFRESH MATERIALIZED VIEW objective_search_terms;
  return NEW; 
end;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_objective_search AFTER INSERT OR UPDATE OR DELETE ON public.objectives
    EXECUTE FUNCTION public.refresh_objective_search_terms();
CREATE TRIGGER refresh_objective_search AFTER INSERT OR UPDATE OR DELETE ON public.tags_objectives
    EXECUTE FUNCTION public.refresh_objective_search_terms();   
CREATE TRIGGER refresh_objective_search AFTER INSERT OR UPDATE OR DELETE ON public.objectives_objective_packs
    EXECUTE FUNCTION public.refresh_objective_search_terms();   
   

/*
-- exercise search
select * from objectives;
SELECT * FROM objective_search_terms;
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('Path'); --noresult (unexpected), but based on the lexemes in the table it is correct. 
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('Pathfinding'); --2 result (unexpected). There appears to be two search items 

SELECT distinct ID FROM objective_search_terms WHERE tsv @@ plainto_tsquery('Pathfinding'); --2 result (expected). There appears to be two search items from the multiple ways the materialized view was updated from the triggers 
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('Jason'); --noresult (unexpected), but based on the lexemes in the table it is correct.
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('JasonTheMighty'); -- all results (expected)
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('ru'); -- no results
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('run'); -- all results (expected)
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('running'); -- all results (expected)
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('balance'); -- 1 result (expected)
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('exercise'); -- 10 result (expected)
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('3x'); -- 3 results (expected)

-- exercise trigger
insert into objectives (label, description) values ('testing label', 'wilder descriptions');
-- TODO: This should probably be a unique constraint.
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('label'); -- 1 results (expected) 
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('description'); -- 1 results (expected)


-- exercise tags search
insert into tags (label) values ('cycling');
-- TODO: This should probably be a unique constraint.
insert into tags_objectives(tag_id, objective_id) values 
  ('9d9dc02e-197e-459d-9ed7-61cdaffddd06', 'e8269e3f-8c73-431b-abad-b8acaf21ab47'), -- explore 
  ('9d9dc02e-197e-459d-9ed7-61cdaffddd06', '1a0cc435-2cb1-4022-8224-84057d8e4d29'); -- backward

SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('cycle'); -- 2 results (expected)
select o.id, o.label, o.description, tags.label as tag_label, op.label as pack_label, op.description as pack_description, up.display_name  
 from objectives o  
 left join tags_objectives tob on 
 	tob.objective_id = o.id 
 left join tags on 
 	tags.id = tob.tag_id  
 left join objectives_objective_packs oop on 
 	oop.objective_id = o.id 
 left join objective_packs op on 
 	op.id = oop.objective_pack_id 
 left join user_profiles up on 
 	up.id = op.user_id  	
 where o.id in ( 
   SELECT id FROM objective_search_terms WHERE tsv @@ plainto_tsquery('cycle') 
 ); 


-- TRY TO PULL BACK THE ASSOCIATED IDS FOR TAGS, PACKS, and USERS
select o.id, o.label, o.description from objectives o;
select o.id from objectives o where o.label = 'Practical Movement';

-- setting up additional tags for testing array queries.
select * from tags;
insert into tags (label) values ('cycling');
select id from tags where label='cycling';

insert into tags_objectives(tag_id, objective_id) values  
   ((select id from tags where label='cycling'), (select o.id from objectives o where o.label = 'Practical Movement')); 

-- setting up additional packs for testing array queries.
select * from user_profiles;
select * from objective_packs op ;
insert into objective_packs (label, description, user_id) values ('Cycling', 'A collection of objectives for Cycling', (select id from user_profiles where display_name='JasonTheMighty' ));
insert into objectives_objective_packs (objective_id, objective_pack_id) values  
   ((select o.id from objectives o where o.label = 'Practical Movement'), (select id from objective_packs where label='Cycling')); 



-- This query returns the ids of objective associated data.
select 
  o.id, 
  o.label,
  o.description, 
  array(
    select distinct tags.id 
	from tags_objectives tob, tags
	where 
	      tob.objective_id = o.id 
	  and tob.tag_id = tags.id
  ) as tag_ids,
  array(
    select distinct op.id 
	from objectives_objective_packs oop, objective_packs op 
	where 
	      oop.objective_id  = o.id 
	  and oop.objective_pack_id  = op.id
  ) as objective_pack_ids,
  array (
    select distinct up.id 
	from objectives_objective_packs oop, objective_packs op, user_profiles up  
	where 
	      oop.objective_id  = o.id 
	  and oop.objective_pack_id  = op.id
	  and op.user_id = up.id
   ) as user_ids
 from objectives o  
 where o.id in ( 
   SELECT id FROM objective_search_terms WHERE tsv @@ plainto_tsquery('Practical Movement') 
 );  
*/
