create table "public"."objective_packs" (
    "id" uuid not null default uuid_generate_v4(),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "label" character varying not null,
    "description" text not null,
    "user_id" uuid default auth.uid(),
    "published_at" timestamp with time zone
);


alter table "public"."objective_packs" enable row level security;

create table "public"."objectives_objective_packs" (
    "objective_id" uuid not null,
    "objective_pack_id" uuid not null
);


CREATE UNIQUE INDEX objective_pack_pkey ON public.objective_packs USING btree (id);

alter table "public"."objective_packs" add constraint "objective_pack_pkey" PRIMARY KEY using index "objective_pack_pkey";

alter table "public"."objective_packs" add constraint "objective_packs_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_profiles(id) not valid;

alter table "public"."objective_packs" validate constraint "objective_packs_user_id_fkey";

alter table "public"."objectives_objective_packs" add constraint "objectives_objective_packs_objective_id_fkey" FOREIGN KEY (objective_id) REFERENCES objectives(id) not valid;

alter table "public"."objectives_objective_packs" validate constraint "objectives_objective_packs_objective_id_fkey";

alter table "public"."objectives_objective_packs" add constraint "objectives_objective_packs_objective_pack_id_fkey" FOREIGN KEY (objective_pack_id) REFERENCES objective_packs(id) not valid;

alter table "public"."objectives_objective_packs" validate constraint "objectives_objective_packs_objective_pack_id_fkey";

create policy "Enable all for owner"
on "public"."objective_packs"
as permissive
for all
to authenticated
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));


create policy "Enable insert for authenticated users"
on "public"."objective_packs"
as permissive
for insert
to authenticated
with check ((auth.role() = 'authenticated'::text));


create policy "Read objective_packs if published"
on "public"."objective_packs"
as permissive
for select
to authenticated
using ((published_at IS NOT NULL));


create policy "admin all"
on "public"."objective_packs"
as permissive
for all
to authenticated
using ((system_role_id() IN ( SELECT roles.id
   FROM roles
  WHERE ((roles.label)::text = 'admin'::text))))
with check ((system_role_id() IN ( SELECT roles.id
   FROM roles
  WHERE ((roles.label)::text = 'admin'::text))));



