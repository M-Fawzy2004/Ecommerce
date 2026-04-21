-- Enable UUID helper
create extension if not exists "pgcrypto";

-- Optional categories master table
create table if not exists public.product_categories (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text null,
  category_id text null references public.product_categories(key) on delete set null,
  category_name text null,
  price numeric(12,2) null,
  sale_price numeric(12,2) null,
  currency text null,
  stock_qty int null,
  unlimited_stock boolean not null default false,
  stock_status text null,
  sku text null,
  is_featured boolean not null default false,
  weight_kg numeric(10,3) null,
  weight_unit text null default 'kg',
  length_cm numeric(10,2) null,
  width_cm numeric(10,2) null,
  height_cm numeric(10,2) null,
  dimension_unit text null default 'cm',
  specs jsonb null,
  main_image_url text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint products_weight_unit_check
    check (weight_unit is null or weight_unit in ('mg', 'g', 'kg', 'lb', 'oz', 'ton')),
  constraint products_dimension_unit_check
    check (dimension_unit is null or dimension_unit in ('mm', 'cm', 'm', 'in', 'ft', 'yd'))
);

create table if not exists public.product_images (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  image_url text not null,
  source_type text not null check (source_type in ('upload', 'external')),
  is_primary boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.product_color_stocks (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  color_name text not null,
  color_hex text null,
  quantity int not null default 0,
  unlimited boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_products_category on public.products(category_id);
create index if not exists idx_product_images_product on public.product_images(product_id);
create index if not exists idx_product_color_stocks_product on public.product_color_stocks(product_id);

-- Enable RLS and add policies for product CRUD
alter table public.products enable row level security;
alter table public.product_images enable row level security;
alter table public.product_color_stocks enable row level security;

drop policy if exists "Public select products" on public.products;
create policy "Public select products"
on public.products for select
using (true);

drop policy if exists "Public insert products" on public.products;
create policy "Public insert products"
on public.products for insert
with check (true);

drop policy if exists "Public update products" on public.products;
create policy "Public update products"
on public.products for update
using (true)
with check (true);

drop policy if exists "Public delete products" on public.products;
create policy "Public delete products"
on public.products for delete
using (true);

drop policy if exists "Public select product_images" on public.product_images;
create policy "Public select product_images"
on public.product_images for select
using (true);

drop policy if exists "Public insert product_images" on public.product_images;
create policy "Public insert product_images"
on public.product_images for insert
with check (true);

drop policy if exists "Public update product_images" on public.product_images;
create policy "Public update product_images"
on public.product_images for update
using (true)
with check (true);

drop policy if exists "Public delete product_images" on public.product_images;
create policy "Public delete product_images"
on public.product_images for delete
using (true);

drop policy if exists "Public select product_color_stocks" on public.product_color_stocks;
create policy "Public select product_color_stocks"
on public.product_color_stocks for select
using (true);

drop policy if exists "Public insert product_color_stocks" on public.product_color_stocks;
create policy "Public insert product_color_stocks"
on public.product_color_stocks for insert
with check (true);

drop policy if exists "Public update product_color_stocks" on public.product_color_stocks;
create policy "Public update product_color_stocks"
on public.product_color_stocks for update
using (true)
with check (true);

drop policy if exists "Public delete product_color_stocks" on public.product_color_stocks;
create policy "Public delete product_color_stocks"
on public.product_color_stocks for delete
using (true);

-- Updated_at trigger
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_products_updated_at on public.products;
create trigger trg_products_updated_at
before update on public.products
for each row execute procedure public.set_updated_at();

-- Storage bucket for uploaded images
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

-- Example open policies (adapt for your auth model)
drop policy if exists "Public read product images" on storage.objects;
create policy "Public read product images"
on storage.objects for select
using (bucket_id = 'product-images');

-- Migration-safe alters for existing databases
do $$
declare
  fk_name text;
begin
  select tc.constraint_name into fk_name
  from information_schema.table_constraints tc
  where tc.table_schema = 'public'
    and tc.table_name = 'products'
    and tc.constraint_type = 'FOREIGN KEY'
    and tc.constraint_name like '%category_id%';

  if fk_name is not null then
    execute format('alter table public.products drop constraint %I', fk_name);
  end if;
end $$;

alter table public.products
  alter column category_id type text using category_id::text;
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'products_category_id_fkey'
  ) then
    alter table public.products
      add constraint products_category_id_fkey
      foreign key (category_id)
      references public.product_categories(key)
      on delete set null;
  end if;
end $$;
alter table public.products
  add column if not exists weight_unit text null default 'kg';
alter table public.products
  add column if not exists dimension_unit text null default 'cm';

alter table public.products
  drop constraint if exists products_weight_unit_check;
alter table public.products
  add constraint products_weight_unit_check
  check (weight_unit is null or weight_unit in ('mg', 'g', 'kg', 'lb', 'oz', 'ton'));

alter table public.products
  drop constraint if exists products_dimension_unit_check;
alter table public.products
  add constraint products_dimension_unit_check
  check (dimension_unit is null or dimension_unit in ('mm', 'cm', 'm', 'in', 'ft', 'yd'));

drop policy if exists "Public upload product images" on storage.objects;
create policy "Public upload product images"
on storage.objects for insert
with check (bucket_id = 'product-images');

drop policy if exists "Public update product images" on storage.objects;
create policy "Public update product images"
on storage.objects for update
using (bucket_id = 'product-images');

drop policy if exists "Public delete product images" on storage.objects;
create policy "Public delete product images"
on storage.objects for delete
using (bucket_id = 'product-images');
