# PRODUCT.md — Chakula Chetu

## Platform
Single-page, no-build static web app (`index.html` + a handful of images). Client-side rendering and logic; Supabase (Postgres + RLS) for shared public reviews. Deployed on Vercel.

## Primary users
- Parents
- Grandparents
- Nurses
- Nannies / other caregivers

All are assumed to be busy, sometimes tired, often on a phone, sometimes cooking or holding a baby while using the app.

## Primary job (the product)
**Generate a weekly baby-weaning meal plan based on the baby's age/stage**, in a form that's easy to scan, save, share, print, or add to a calendar.

Journey: land → understand what this is → select baby's age → see the week's plan → save / share / print / calendar → optionally learn more.

## Secondary jobs
- Learn *why* meals are paired the way they are (iron + vitamin C, fat + vitamin A)
- Browse the food library for the current stage
- Learn responsive-feeding cues (hunger/fullness)
- Learn general growth/nutrition red flags (education, not diagnosis)
- Read/leave reviews
- Learn about the founder and optionally support the project (M-Pesa donation)
- Give lightweight product feedback

## Evidence this document is based on
- The live application at `https://chakula-chetu.vercel.app/`
- The full source of `index.html` (markup, CSS, and the plan-generation logic) as of this session
- `README.md` (architecture, Supabase setup, editing instructions)
- `SUPABASE_SETUP.sql` (reviews table + RLS policies)
- The existing founder story in the About section and its photo asset
- The existing FAQ, WATCH_ITEMS, DIGESTION_TIPS, and STAGES data already in the app

No user research, analytics, survey data, or business metrics were available or invented for this document — evidence above is the entire basis for the product framing. Anything about *why* a section exists beyond what's visible in the code or README is inference from context, not confirmed fact, and is flagged as such in DESIGN.md where relevant.

## Non-goals for this pass
- No framework/build-system migration (Next.js, React, Tailwind compiler, etc.)
- No rewriting of the meal-generation algorithm
- No new medical/nutritional claims or content
- No new pages — the single-page anchor-navigation architecture is preserved
