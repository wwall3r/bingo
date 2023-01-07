drop materialized view if exists objective_search_terms ;

create materialized view objective_search_terms
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

-- exercise objective_packs search
insert into objective_packs (label, description, user_id) values ('exercise', 'random exercise objectives', 'ecf15eee-ddeb-40bc-a63e-a507bc26df52'); -- by william
-- TODO: This should probably be a unique constraint.
delete from objectives_objective_packs where objective_pack_id =  '7c527d99-3574-4252-9cdf-3957d31ac46d';
insert into objectives_objective_packs (objective_pack_id, objective_id) values
 ('7c527d99-3574-4252-9cdf-3957d31ac46d','3da44275-c8c8-4dc7-8317-cd99638d5693'), -- long podcast 
 ('7c527d99-3574-4252-9cdf-3957d31ac46d','6f49ea5f-47e3-431e-b1e9-6983ebef5837'); -- practical movement
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('Will'); -- 0 results (unexpected) You're a Will is a 'stop' word
SELECT * FROM objective_search_terms WHERE tsv @@ plainto_tsquery('random'); -- 2 results (expected) You're a Will is a 'stop' word


