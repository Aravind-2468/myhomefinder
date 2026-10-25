# MyHome Finder — Multi-page real estate website

A responsive Next.js + Supabase starter for MyHome Finder.

## Included
- Separate Home, Properties, Flats, Houses, Plots, About and Contact pages
- Supabase-backed property listings and enquiry form
- Private admin login using Supabase Auth
- Admin dashboard to add, edit, publish/unpublish and delete listings
- Admin enquiry tracker
- Responsive layout
- SQL schema with row-level security (RLS)

## Free-first setup
You need:
- Node.js 20 or newer
- A free Supabase account/project
- A free Vercel account if you later want to publish online (optional while developing locally)

## 1. Create the Supabase database
1. Create a project at https://supabase.com/
2. Open **SQL Editor** in your Supabase project.
3. Copy all of `supabase/schema.sql` into the editor and run it.
4. Open **Project Settings → API** and copy the Project URL and anon/public key.

## 2. Configure the app
1. Install Node.js 20+ from https://nodejs.org/
2. Extract this ZIP and open a terminal in the `myhome-finder-project` folder.
3. Copy `.env.example` to a new file named `.env.local`.
4. Fill in your Supabase URL and anon key:
   - `NEXT_PUBLIC_SUPABASE_URL=...`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY=...`
5. Run:
   ```bash
   npm install
   npm run dev
   ```
6. Open http://localhost:3000

## 3. Create your private admin login
1. In Supabase, open **Authentication → Users → Add user**.
2. Create the email/password you will use as the admin.
3. In **SQL Editor**, run this, replacing the email with your admin email:
   ```sql
   insert into public.admin_users (user_id)
   select id from auth.users where email = 'you@example.com'
   on conflict do nothing;
   ```
4. Visit `/admin/login` and sign in.
5. The admin dashboard is at `/admin`.

Only users whose Supabase user ID is in `admin_users` can access the admin data. Do not put a Supabase service-role key in the browser or commit it to source control.

## 4. Add property listings
From `/admin`, choose **Add property**. Enter a title, category, location, price, bedrooms/size, description and an image URL. Use an image URL you have permission to use. Publish the listing when ready.

For a first free version, image URLs keep setup simple. You can add Supabase Storage uploads later.

## 5. Enquiries
The Contact form stores enquiries in Supabase. In `/admin`, open Enquiries to review them and update their status. The public form never exposes other people's enquiries.

## 6. Publish online (optional)
1. Push this project to a private GitHub repository.
2. Import it into Vercel.
3. Add the same `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` environment variables in Vercel.
4. Deploy.

Free plans have usage limits and terms can change. A custom domain is optional and usually costs money.

## Before launch
- Replace the example listings and image URLs with genuine, owner-authorised listings.
- Confirm prices, sizes, availability, permissions and brokerage terms.
- Have property documents independently checked by a qualified professional; don't label a property “legally verified” without appropriate verification.
- Add your actual business phone/WhatsApp details and privacy notice.
- Configure Supabase Auth redirect URLs for your production domain.
- Test admin permissions and the enquiry flow before public launch.

## Routes
- `/` home
- `/properties` all published listings
- `/flats`, `/houses`, `/plots` category pages
- `/properties/[id]` detail page
- `/about`, `/contact`
- `/admin/login`, `/admin`, `/admin/properties/new`, `/admin/properties/[id]`, `/admin/enquiries`

This is a working starter project, not a hosted live website. You must configure Supabase and deploy it to make it public.
