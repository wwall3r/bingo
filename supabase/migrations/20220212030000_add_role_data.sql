INSERT INTO public.roles (id, created_at, label, description)
VALUES
('46dd06a8-d4f7-47d7-ab7c-cdd88671d0d0', '2022-02-12 01:46:16+00'::timestamp, 'viewer', 'viewer: A system user that can read public information.'),
('c94a1b68-4ba7-410d-93c1-251157f22522', '2022-02-12 01:46:58+00'::timestamp, 'editor', 'editor: A system user that can permissions to perform limited inserts and updates to the core system.'),
('a354132a-565a-489c-8717-e596fe18219c', '2022-02-12 01:47:41+00'::timestamp, 'admin',	'admin: A system user that can perform all operations on the system'),
('35d824bd-96cf-4f2e-9b97-fa073b17f7ad', '2022-02-12 01:48:30+00'::timestamp, 'keeper',	'keeper: A game user that assists the administrator in editing items related to a game.'),
('8909c101-2de4-4713-b8b1-b4573bfa4c50', '2022-02-12 01:48:08+00'::timestamp, 'player',	'player: A game user with minimum privileges'),
('91e5b01e-584e-4a02-b619-fef75fac22ac', '2022-02-12 01:50:10+00'::timestamp, 'owner',	'owner: A game user that has full control over the editable items in a game');

