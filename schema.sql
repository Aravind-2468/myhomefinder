create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null check (category in ('Flat','House','Plot','Villa','Agricultural Land','Commercial')),
  location text not null,
  mandal text,
  price numeric(14,2) not null default 0,
  price_unit text not null default 'INR',
  bedrooms integer,
  bathrooms integer,
  area_value numeric(12,2),
  area_unit text default 'sq ft',
  image_url text,
  description text,
  features text[] not null default '{}',
  status text not null default 'draft' check (status in ('draft','published','sold')),
  owner_authorised boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.enquiries (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  email text,
  enquiry_type text not null default 'Buy',
  property_id uuid references public.properties(id) on delete set null,
  preferred_location text,
  budget text,
  message text,
  status text not null default 'new' check (status in ('new','contacted','visit_planned','closed')),
  created_at timestamptz not null default now()
);

create or replace function public.is_mhf_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.admin_users where user_id = auth.uid()); $$;

alter table public.admin_users enable row level security;
alter table public.properties enable row level security;
alter table public.enquiries enable row level security;

drop policy if exists "Admins can read admin_users" on public.admin_users;
create policy "Admins can read admin_users" on public.admin_users for select to authenticated using (public.is_mhf_admin());

drop policy if exists "Public can read published properties" on public.properties;
create policy "Public can read published properties" on public.properties for select to anon, authenticated using (status = 'published' or public.is_mhf_admin());

drop policy if exists "Admins can insert properties" on public.properties;
create policy "Admins can insert properties" on public.properties for insert to authenticated with check (public.is_mhf_admin());

drop policy if exists "Admins can update properties" on public.properties;
create policy "Admins can update properties" on public.properties for update to authenticated using (public.is_mhf_admin()) with check (public.is_mhf_admin());

drop policy if exists "Admins can delete properties" on public.properties;
create policy "Admins can delete properties" on public.properties for delete to authenticated using (public.is_mhf_admin());

drop policy if exists "Anyone can submit an enquiry" on public.enquiries;
create policy "Anyone can submit an enquiry" on public.enquiries for insert to anon, authenticated with check (
  length(trim(name)) between 1 and 100 and length(trim(phone)) between 5 and 30
);

drop policy if exists "Admins can read enquiries" on public.enquiries;
create policy "Admins can read enquiries" on public.enquiries for select to authenticated using (public.is_mhf_admin());

drop policy if exists "Admins can update enquiries" on public.enquiries;
create policy "Admins can update enquiries" on public.enquiries for update to authenticated using (public.is_mhf_admin()) with check (public.is_mhf_admin());

create index if not exists properties_status_category_idx on public.properties(status, category);
create index if not exists properties_location_idx on public.properties(location);
create index if not exists enquiries_created_at_idx on public.enquiries(created_at desc);
