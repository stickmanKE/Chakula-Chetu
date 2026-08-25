# Chakula Chetu — Kenyan Baby Weaning Planner

A single-page, no-build static site. No npm install needed — it's just `index.html`.

## Deploy to Vercel (fastest way)

**Option A — Vercel CLI**
```
npm i -g vercel
cd baby-meal-planner
vercel
```
Accept the defaults (framework: "Other"). Vercel will give you a live URL in under a minute.

**Option B — Vercel dashboard (no terminal)**
1. Go to vercel.com → New Project → "Import" or drag-and-drop this folder.
2. Framework preset: **Other** (it's plain HTML, no build step).
3. Deploy. Done.

**Option C — GitHub**
1. Push this folder to a new GitHub repo.
2. On vercel.com, "New Project" → import that repo → Deploy.
3. Every future push auto-deploys.

## Editing content later
Everything — the food lists, stages, tips — lives in the `STAGES` and `DIGESTION_TIPS` objects near the top of the `<script>` tag in `index.html`. No build tools required; edit and redeploy.
