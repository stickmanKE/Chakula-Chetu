# Chakula Chetu — Kenyan Baby Weaning Planner

A single-page, no-build static site for Kenyan parents, caregivers and nurses — local foods, gentle on digestion, from first tastes to family table.

**Live:** [chakula-chetu.vercel.app](https://chakula-chetu.vercel.app/)
**Repo:** [github.com/stickmanKE/Chakula-Chetu](https://github.com/stickmanKE/Chakula-Chetu)

## Project structure

```
.
├── index.html         — everything: markup, styles, and the planner logic
├── favicon.ico         — browser tab icon
├── SUPABASE_SETUP.sql   — run once in Supabase to create the reviews table
└── images/
    ├── mark-and-baby.jpg     — About section photo
    ├── favicon-16x16.png     — favicon (small)
    ├── favicon-32x32.png     — favicon (standard)
    └── apple-touch-icon.png  — iOS/Android home screen icon
```

No npm install needed — it's just `index.html` plus a handful of image assets. The site talks directly to Supabase from the browser, so there's still no build step and no server to run.

## Reviews backend (Supabase)

Public reviews are stored in a shared Supabase (Postgres) table, so every visitor sees the same list — not just the device that submitted a review. One-time setup:

1. Create a free project at [supabase.com](https://supabase.com).
2. In the SQL Editor, run everything in `SUPABASE_SETUP.sql` — this creates the `reviews` table and the access rules that let visitors submit and read reviews safely.
3. Go to Supabase → Settings → API Keys, and copy the **Project URL** and your client-side key:
   - Newer projects show this as the **Publishable key** (starts with `sb_publishable_...`) under an "API Keys" tab.
   - Older projects show it as the **anon public** key (a long JWT string) under "Project API keys".
   - Either one works identically here — use whichever your project shows you.
4. In `index.html`, near the top of the `<script>` tag, replace:
   ```js
   const SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co';
   const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';
   ```
   with your real values, then commit and push.

The client-side key is meant to be public — it can only do what the Row Level Security policies in `SUPABASE_SETUP.sql` allow (submit a review, read reviews marked public). Nothing sensitive is exposed by it.

**Migrating early reviews:** if a browser collected any reviews before the Supabase backend existed, they're sitting in its local storage under the old `chakula_chetu_reviews` key. The first time this updated `index.html` loads *in that same browser* with real Supabase credentials filled in, it automatically pushes any of those reviews that were marked "show publicly" into the new backend, then clears the old local copy. This only works per-browser — there's no way to recover reviews from a device that already cleared its storage, since that data never left the visitor's device in the first place. Reviews saved *without* the public-consent checkbox are left alone and cleared rather than migrated, since moving them into a shared database would go beyond what was originally agreed to.

The "How are we doing?" feedback widget (separate from reviews) still saves to the visitor's own browser only — it's a private pulse-check, not meant to be public.

## Deploying changes

This repo is already connected to Vercel — every push to `main` auto-deploys within about a minute. To deploy elsewhere or set it up fresh:

**Option A — Vercel CLI**
```
npm i -g vercel
cd Chakula-Chetu
vercel
```
Accept the defaults (framework: "Other").

**Option B — Vercel dashboard (no terminal)**
1. Go to vercel.com → New Project → import this repo (or drag-and-drop the folder).
2. Framework preset: **Other** (it's plain HTML, no build step).
3. Deploy.

## Editing content later

Everything — the food lists, stages, tips — lives in the `STAGES` and `DIGESTION_TIPS` objects near the top of the `<script>` tag in `index.html`. No build tools required; edit and push to `main` to redeploy.

Images (the About photo, favicons) live in `images/`. Reference them as `images/filename.ext` from `index.html`.
