--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1 (Debian 14.1-1.pgdg110+1)
-- Dumped by pg_dump version 14.1 (Ubuntu 14.1-2.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games (id, label, description, board_size, created_at, updated_at) FROM stdin;
408957cc-06bc-42a6-a005-4d48693ce578	The Running Man	A Bingo Game for Runners	5	2022-01-30 14:27:50+00	2022-01-30 14:27:50+00
\.


--
-- Data for Name: objectives; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.objectives (id, created_at, updated_at, label, description) FROM stdin;
2e569ed6-93a6-4cd4-9ffa-3864b790bd49	2022-01-30 03:58:23+00	2022-01-30 03:58:23+00	Recovery Run	Do a recovery run at a 120% minute per mile pace. If your normal mile is 10 minutes, keep a 12 minute per mile pace.
e4144e0e-253e-4f07-bf96-50bcb2f2f126	2022-01-30 03:59:39+00	2022-01-30 03:59:39+00	Bonus Weight	Run with extra weight (backpack, arm/leg/belt weights, etc)
b5940194-457b-40ed-99dd-6e0011a78d91	2022-01-30 04:00:30+00	2022-01-30 04:00:30+00	Early Bird / Night Owl	Run before 7am or after 7pm. Be sure to wear reflective or bright clothing!
71cc4fa4-68e8-4216-bea1-12fa6317cd7f	2022-01-30 04:01:17+00	2022-01-30 04:01:17+00	Media Recommendation	Go exercise with entertainment recommended by someone else.
8b887542-d444-47b0-9a98-865d8649fe44	2022-01-30 04:03:16+00	2022-01-30 04:03:16+00	Sunny Skies	Skip the exercise machine! Exercise outdoors when the sun is out.
a0a7a569-d96d-403f-b771-cab51f6d2a24	2022-01-30 04:04:27+00	2022-01-30 04:04:27+00	3x Circuits	Complete a run that involves 3+ laps
4802b94f-e495-43d8-acf9-a26f4ac81493	2022-01-30 04:02:35+00	2022-01-30 04:05:33.034122+00	3x Endurance	Go on an 8+ mile run at least 3 times
3da44275-c8c8-4dc7-8317-cd99638d5693	2022-01-30 04:05:35+00	2022-01-30 04:05:35+00	Story Time	Complete a podcast that's longer than one hour while exercising
bd4af7a9-83cb-4b4b-96ec-9da7e54bb1c0	2022-01-30 04:06:32+00	2022-01-30 04:06:32+00	3x Consistency	Run 3 days in a row
bb416571-efee-4b19-bd5f-723e234befc9	2022-01-30 04:06:50+00	2022-01-30 04:06:50+00	Stretch Day	Focusing on one single aspect of training can lead to injuries. Balance, Strength, Flexibility, and Endurance all need to be addressed.
e8269e3f-8c73-431b-abad-b8acaf21ab47	2022-01-30 04:07:59+00	2022-01-30 04:07:59+00	Pathfinder	Explore an entirely new route
6f49ea5f-47e3-431e-b1e9-6983ebef5837	2022-01-30 04:08:24+00	2022-01-30 04:08:24+00	Practical Movement	Travel the old fashioned way. Run, walk, or bike to work, the library, over to the grocery, or to a friends house.
04ea0d02-6e6f-4e0b-89cc-835e4b39e7f7	2022-01-30 04:09:58+00	2022-01-30 04:11:24.925802+00	Umbrella Weather	Exercise when it is precipitating
9a2c7118-09f7-492e-b0c2-431e98ba60db	2022-01-30 04:11:26+00	2022-01-30 04:11:26+00	Cross Train	4+ mile run where you stop each mile for 20 pushups
afd64a88-afd5-4a43-8f55-81af7bd62224	2022-01-30 04:12:17+00	2022-01-30 04:12:17+00	Silent Retreat	Do a run with no entertainment (enjoy your surroundings)
43eca8ee-011b-481a-9292-28b40c598514	2022-01-30 04:15:09+00	2022-01-30 04:15:09+00	Table for Two	Exercise with someone else 2 times or more
af62f316-0986-42f3-b19d-0d882c0d9934	2022-01-30 04:15:49+00	2022-01-30 04:15:49+00	Push It!	Go for a run and beat your average pace by 5%
53ce1781-7146-4db5-bea3-8a335a910bfc	2022-01-30 04:17:08+00	2022-01-30 04:17:08+00	Run for Record	Exercise and record the results after maximum effort.
970b4e8e-9284-490a-9467-b56007281815	2022-01-30 04:17:42+00	2022-01-30 04:17:42+00	It's a job	Exercise 5 times in 7 days
cd4d67d2-0d5d-4932-a429-6c17ca09f375	2022-01-30 04:18:25+00	2022-01-30 04:18:25+00	In Touch With Nature	Exercise at a park, trail, or nature preserve
15b69c2d-6283-4880-8407-37ca9f6d6b9c	2022-01-30 04:19:49+00	2022-01-30 04:19:49+00	Double Trouble	Exercise twice in one day
6dd07e46-e2d6-477a-aa0c-f2a2083e5e29	2022-01-30 04:20:04+00	2022-01-30 04:20:04+00	Bundle up	Exercise outdoors when it's below 25 degrees
1a0cc435-2cb1-4022-8224-84057d8e4d29	2022-01-30 04:20:37+00	2022-01-30 04:20:37+00	Reverse!	Run a normal route backwards
c1df10ad-107c-4b95-b1b6-911a7fed0897	2022-01-30 04:20:57+00	2022-01-30 04:20:57+00	Elevation	Go on a run with at least 500 ft of elevation change
29d90ab1-1ab7-4b35-80db-c3a05f12070b	2022-01-30 04:42:00+00	2022-01-30 04:42:00+00	Fartlek Run	Fartlek is literally, playing around with speeds – essentially, it’s a form of unstructured speedwork. It involves a continuous run in which periods of faster running are mixed with periods of easy- or moderate-paced running (not complete rest, as with interval training).
\.


--
-- Data for Name: games_objectives_assoc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games_objectives_assoc (game_id, objective_id) FROM stdin;
408957cc-06bc-42a6-a005-4d48693ce578	2e569ed6-93a6-4cd4-9ffa-3864b790bd49
408957cc-06bc-42a6-a005-4d48693ce578	e4144e0e-253e-4f07-bf96-50bcb2f2f126
408957cc-06bc-42a6-a005-4d48693ce578	b5940194-457b-40ed-99dd-6e0011a78d91
408957cc-06bc-42a6-a005-4d48693ce578	71cc4fa4-68e8-4216-bea1-12fa6317cd7f
408957cc-06bc-42a6-a005-4d48693ce578	8b887542-d444-47b0-9a98-865d8649fe44
408957cc-06bc-42a6-a005-4d48693ce578	a0a7a569-d96d-403f-b771-cab51f6d2a24
408957cc-06bc-42a6-a005-4d48693ce578	4802b94f-e495-43d8-acf9-a26f4ac81493
408957cc-06bc-42a6-a005-4d48693ce578	3da44275-c8c8-4dc7-8317-cd99638d5693
408957cc-06bc-42a6-a005-4d48693ce578	bd4af7a9-83cb-4b4b-96ec-9da7e54bb1c0
408957cc-06bc-42a6-a005-4d48693ce578	bb416571-efee-4b19-bd5f-723e234befc9
408957cc-06bc-42a6-a005-4d48693ce578	e8269e3f-8c73-431b-abad-b8acaf21ab47
408957cc-06bc-42a6-a005-4d48693ce578	6f49ea5f-47e3-431e-b1e9-6983ebef5837
408957cc-06bc-42a6-a005-4d48693ce578	04ea0d02-6e6f-4e0b-89cc-835e4b39e7f7
408957cc-06bc-42a6-a005-4d48693ce578	9a2c7118-09f7-492e-b0c2-431e98ba60db
408957cc-06bc-42a6-a005-4d48693ce578	afd64a88-afd5-4a43-8f55-81af7bd62224
408957cc-06bc-42a6-a005-4d48693ce578	43eca8ee-011b-481a-9292-28b40c598514
408957cc-06bc-42a6-a005-4d48693ce578	af62f316-0986-42f3-b19d-0d882c0d9934
408957cc-06bc-42a6-a005-4d48693ce578	53ce1781-7146-4db5-bea3-8a335a910bfc
408957cc-06bc-42a6-a005-4d48693ce578	970b4e8e-9284-490a-9467-b56007281815
408957cc-06bc-42a6-a005-4d48693ce578	cd4d67d2-0d5d-4932-a429-6c17ca09f375
408957cc-06bc-42a6-a005-4d48693ce578	15b69c2d-6283-4880-8407-37ca9f6d6b9c
408957cc-06bc-42a6-a005-4d48693ce578	6dd07e46-e2d6-477a-aa0c-f2a2083e5e29
408957cc-06bc-42a6-a005-4d48693ce578	1a0cc435-2cb1-4022-8224-84057d8e4d29
408957cc-06bc-42a6-a005-4d48693ce578	c1df10ad-107c-4b95-b1b6-911a7fed0897
408957cc-06bc-42a6-a005-4d48693ce578	29d90ab1-1ab7-4b35-80db-c3a05f12070b
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, label, created_at, updated_at) FROM stdin;
37fd9162-c822-44c4-a0ad-2c745656ca9d	Running	2022-01-30 14:48:20+00	2022-01-30 14:48:20+00
\.


--
-- Data for Name: tags_objectives_assoc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags_objectives_assoc (tag_id, objective_id) FROM stdin;
37fd9162-c822-44c4-a0ad-2c745656ca9d	2e569ed6-93a6-4cd4-9ffa-3864b790bd49
37fd9162-c822-44c4-a0ad-2c745656ca9d	e4144e0e-253e-4f07-bf96-50bcb2f2f126
37fd9162-c822-44c4-a0ad-2c745656ca9d	b5940194-457b-40ed-99dd-6e0011a78d91
37fd9162-c822-44c4-a0ad-2c745656ca9d	71cc4fa4-68e8-4216-bea1-12fa6317cd7f
37fd9162-c822-44c4-a0ad-2c745656ca9d	8b887542-d444-47b0-9a98-865d8649fe44
37fd9162-c822-44c4-a0ad-2c745656ca9d	a0a7a569-d96d-403f-b771-cab51f6d2a24
37fd9162-c822-44c4-a0ad-2c745656ca9d	4802b94f-e495-43d8-acf9-a26f4ac81493
37fd9162-c822-44c4-a0ad-2c745656ca9d	3da44275-c8c8-4dc7-8317-cd99638d5693
37fd9162-c822-44c4-a0ad-2c745656ca9d	bd4af7a9-83cb-4b4b-96ec-9da7e54bb1c0
37fd9162-c822-44c4-a0ad-2c745656ca9d	bb416571-efee-4b19-bd5f-723e234befc9
37fd9162-c822-44c4-a0ad-2c745656ca9d	e8269e3f-8c73-431b-abad-b8acaf21ab47
37fd9162-c822-44c4-a0ad-2c745656ca9d	6f49ea5f-47e3-431e-b1e9-6983ebef5837
37fd9162-c822-44c4-a0ad-2c745656ca9d	04ea0d02-6e6f-4e0b-89cc-835e4b39e7f7
37fd9162-c822-44c4-a0ad-2c745656ca9d	9a2c7118-09f7-492e-b0c2-431e98ba60db
37fd9162-c822-44c4-a0ad-2c745656ca9d	afd64a88-afd5-4a43-8f55-81af7bd62224
37fd9162-c822-44c4-a0ad-2c745656ca9d	43eca8ee-011b-481a-9292-28b40c598514
37fd9162-c822-44c4-a0ad-2c745656ca9d	af62f316-0986-42f3-b19d-0d882c0d9934
37fd9162-c822-44c4-a0ad-2c745656ca9d	53ce1781-7146-4db5-bea3-8a335a910bfc
37fd9162-c822-44c4-a0ad-2c745656ca9d	970b4e8e-9284-490a-9467-b56007281815
37fd9162-c822-44c4-a0ad-2c745656ca9d	cd4d67d2-0d5d-4932-a429-6c17ca09f375
37fd9162-c822-44c4-a0ad-2c745656ca9d	15b69c2d-6283-4880-8407-37ca9f6d6b9c
37fd9162-c822-44c4-a0ad-2c745656ca9d	6dd07e46-e2d6-477a-aa0c-f2a2083e5e29
37fd9162-c822-44c4-a0ad-2c745656ca9d	1a0cc435-2cb1-4022-8224-84057d8e4d29
37fd9162-c822-44c4-a0ad-2c745656ca9d	c1df10ad-107c-4b95-b1b6-911a7fed0897
37fd9162-c822-44c4-a0ad-2c745656ca9d	29d90ab1-1ab7-4b35-80db-c3a05f12070b
\.


--
-- PostgreSQL database dump complete
--
