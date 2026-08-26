-- Run this once in Supabase → SQL Editor → New query, then click Run.
-- Creates the shared "reviews" table that index.html reads from and
-- writes to, plus the access rules (Row Level Security) that let
-- visitors submit and read reviews without a server in between.

create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  rating integer check (rating between 0 and 5),
  text text not null,
  useful text,
  name text,
  role text,
  county text,
  consented boolean not null default false
);

-- Row Level Security is off by default until you enable it — this
-- keeps the table locked down to only what the two policies below
-- explicitly allow, even though the anon key is public.
alter table reviews enable row level security;

-- Anyone can submit a review (this is the public review form).
create policy "Anyone can submit a review"
  on reviews for insert
  to anon
  with check (true);

-- Anyone can read reviews the author agreed to show publicly.
-- Reviews submitted without the consent checkbox stay invisible —
-- there's no way to read them back through the public API.
create policy "Anyone can read consented reviews"
  on reviews for select
  to anon
  using (consented = true);
