# DESIGN.md — Chakula Chetu

Design lens: **Operate first, Read second, Brand third** (Impeccable). The visitor is here to generate and use a meal plan; education and trust-building support that task, they don't compete with it.

---

## 1. Strengths (preserve)

- Kenyan food-inspired palette with a real point of view (sukuma green, sweet potato, egg yolk, ndengu) — not generic wellness pastel or SaaS blue/purple.
- Fraunces + Work Sans + JetBrains Mono is a genuinely good, restrained pairing already in place.
- The generator already does real work: iron-day scheduling, vitamin-C/A pairing logic, adjacent-day and same-day repeat avoidance. This is a real differentiator and was **not** touched.
- Multiple export paths already exist and work: save (device-local, clearly labelled), WhatsApp, `.ics` calendar, copy-as-text, print.
- Reviews already have real empty/loading/error states, and a real consent model (unconsented reviews are technically unreadable via the public API, per RLS — not just hidden in the UI).
- The founder story is specific and human, not a generic "our mission" block.
- Medical/nutrition framing is already careful: "general guidance, not a diagnosis" language already exists in the Growth Watch and Guidance sections and the footer.

## 2. Weaknesses found (this pass)

**P0 — real bugs / real accessibility failures**
- `savePlan()` showed "Plan saved ✓" even when `localStorage.setItem` threw (e.g. private browsing) — a false-success message. **Fixed.**
- Clipboard copy (`copy-btn`, `copy-mpesa-btn`) had no `.catch()` — silent failure. **Fixed.**
- Two real WCAG contrast failures: white text on `--sweet-potato` background (3.09:1, needs 4.5:1) on the primary "Generate my week" button and mobile-bar Generate button; `--sweet-potato` text-on-cream used for 7 section eyebrows (2.86:1, needs 3:1 even for large text). **Fixed** with two new tokens, `--sweet-potato-deep` (5.07:1) and `--sweet-potato-text` (5.21:1) — see §4.
- Heading outline skipped from `<h1>` straight to ten independent sibling `<h3>`s with no `<h2>`, which misrepresents the page structure to screen-reader users navigating by heading. **Fixed** — see the new outline in §5.
- No `prefers-reduced-motion` handling despite entrance animation on every day card and `scroll-behavior: smooth` site-wide. **Fixed.**
- No screen-reader announcement when a plan is (re)generated — sighted users see new cards appear; screen-reader users get no signal anything changed. **Fixed** with a polite live region.
- Feedback modal had no focus management (focus stayed on the trigger button behind the sheet), no Escape-to-close, and no visible-to-AT dialog semantics. **Fixed.**

**P1 — hierarchy / clarity**
- The five post-generation actions (Save, Calendar, WhatsApp, Copy, Print) were all styled identically — no signal of which one matters most. **Fixed**: Save is now the visually heaviest, WhatsApp/Calendar are secondary, Copy/Print are low-emphasis text-style actions.
- Printing the page printed *everything* — reviews form, donation block, About, FAQ — instead of a usable fridge-reference sheet. **Fixed**: print now shows only the stage, the week, nutrient tags, and one safety line (reused verbatim from the existing footer text).
- The connection between "tap an age" (which auto-generates a plan and scrolls down) and the separate "Generate my week" button (which reshuffles) wasn't stated anywhere, so a first-time visitor could reasonably not realise the plan below already updated. **Fixed** with one clarifying line under the age grid.
- "Why some foods are paired on purpose" — a genuine product differentiator — lived far down the page with equal visual weight to reviews/FAQ. **Fixed** with a one-line, low-emphasis teaser + anchor link right under the stage's texture/portion/focus strip, without duplicating or removing the full section.
- Subnav labels ("Smart pairing", "Food library", "Growth watch", "Golden rules") were long enough to make the horizontal mobile scroll-nav busy. **Fixed** by shortening labels; all ten anchors were kept (nothing removed).
- Seven day-cards stack fully vertically under 640px with no way to jump to a specific day. Brief explicitly warns against *hiding* content to solve this (accordions, etc.), so instead of hiding anything, a horizontal "Mon Tue Wed…" jump strip was added above the plan grid, mobile-only (it's redundant once the grid goes multi-column at `sm:`). **Fixed**, additive only — every day's full content is still always visible on the page.

**P2 — smaller items fixed opportunistically**
- `window.open(url, '_blank')` for WhatsApp share had no `noopener,noreferrer`. **Fixed.**
- Decorative emoji inside buttons that already have visible text (💾 Save plan, 📅 Add to calendar, mood/role picker faces, etc.) weren't marked `aria-hidden`, so screen readers could double-announce them. **Fixed** on the instances touched this pass.
- Star-rating buttons and age-stage buttons had no `aria-pressed`/group semantics reflecting selection state. **Fixed.**

**P3 — flagged, not changed**
- The hero's "paired the way a nutritionist would" line is a soft professional-authority claim. Per the brief's own instruction (§34), this needs **your confirmation**, not a silent edit: was a nutritionist actually involved in developing or reviewing the pairing logic? If not, consider something like *"paired the way a nutritionist recommends"* or dropping the professional reference entirely. I did not change this copy.
- "Swap freely within a group" (Food Library intro copy) reads like it describes an in-app swap *feature*, but no such interaction exists in the code — the library is read-only reference content. This is plausibly just meant as cooking advice ("feel free to substitute while you cook"), which is a reasonable and true reading, so I did not change it — but it's worth you confirming the intended meaning, since a caregiver could reasonably expect a tappable swap control.
- The focus-visible outline color (`var(--sweet-potato)`) sits at 2.86:1 against light backgrounds (just under the 3:1 non-text minimum) but at 3.14:1 against the dark sukuma card — a single color can't satisfy both contexts. Given how close it already is and that it's a secondary indicator (focus is still visible via position/outline shape), I left this alone rather than adding context-specific overrides, but it's a legitimate minor finding if you want it addressed later.
- No nutritionist/pediatric credential, clinical review, or government-approval claim was found anywhere in the code — good, and nothing was added.

## 3. Product hierarchy (as implemented)

1. **Core**: age selection → generated weekly plan → save/share/print/calendar
2. **Useful**: saved plans, smart-pairing explanation, food library
3. **Guidance**: hunger/fullness cues, golden rules, tummy guidance, growth watch
4. **Trust**: reviews, about
5. **Support**: donation, feedback
6. **Reference**: FAQ

This was already roughly the page order; the main change was *visual* weight (button hierarchy, print scope, the pairing teaser) rather than reordering sections.

## 4. Design system additions

New CSS custom properties (all additive — nothing removed from the existing palette):

| Token | Hex | Contrast | Used for |
|---|---|---|---|
| `--sweet-potato` | `#E0762C` | (unchanged) | borders, hover accents, decorative bullets/markers on mixed backgrounds |
| `--sweet-potato-deep` | `#AE5619` | 5.07:1 vs white | solid-fill buttons carrying white text (`.btn-primary`, mobile Generate) |
| `--sweet-potato-text` | `#A84D18` | 5.21:1 vs cream | small eyebrow/label text on light backgrounds |

New utility/component classes:
- `.sr-only` — visually-hidden, screen-reader-only text (used for the plan-status live region)
- `.print-only` — hidden on screen, shown only in `@media print`
- `.btn-subtle` — low-emphasis tertiary action (Copy text, Print/PDF)
- `.day-quicknav` — mobile-only horizontal day-jump strip

## 5. New heading outline

```
H1 Meal plans your baby's stomach will thank you for.
 H2 5–6 months (dynamic stage name)
 H2 This week's plan
 H2 My saved plans
 H2 Why some foods are paired on purpose
  H3 Vitamin C helps iron absorb
  H3 Fat helps vitamin A absorb
 H2 Foods for this stage
 H2 Signs baby is hungry
 H2 Signs baby is full
 H2 What poor nutrition can look like
 H2 Introducing new foods safely
 H2 If baby's tummy is unsettled
 H2 How Chakula Chetu helps families
  H3 [review form question]
 H2 Common questions
 H2 Hi, I'm Mark Mgharo
 H3 How are we doing? (modal dialog title — separate context)
```
Verified programmatically; no skipped levels in the main document flow.

## 6. Mobile strategy

- Kept the existing single-column → 2-col → 3-col grid breakpoints (already sound).
- Added the day quick-nav strip (see §2 P1) so "what's Tuesday lunch?" doesn't require scrolling past six other days — without hiding any content behind an accordion, per the brief's explicit instruction.
- Mobile action bar (Generate / Save / Calendar) was left as-is — it already follows the brief's "only the most useful actions" guidance.
- Print layout was scoped down specifically because print is a mobile-adjacent use case here (a caregiver printing/PDF-ing a plan to keep on a phone or fridge).

## 7. Accessibility strategy

Addressed this pass: reduced motion, live-region plan announcements, heading hierarchy, modal focus trap + Escape + dialog semantics, `aria-pressed` on age/star selectors, `aria-hidden` on decorative emoji/icons, two real contrast failures.

Not yet done (see "Remaining issues" in the final report): a full keyboard-only walkthrough of the review form and FAQ accordion, a full audit of every color pair in the file (only the ones actually failing were fixed — see §4), and testing with an actual screen reader (this was a static-code review, not a live AT test).

## 8. Performance strategy

No new dependencies, no new fonts, no build step introduced. All changes are markup/CSS/vanilla-JS additions inside the existing single file. The one new runtime behavior (day quick-nav render) is O(7) per generation — negligible.

## 9. What was deliberately *not* done

- No conversion to a framework or multi-file architecture (file is workable at ~1,780 lines; a split into `index.html` / `styles.css` / `app.js` / `data.js` is a reasonable *future* improvement but wasn't necessary to justify the risk this pass).
- No rewrite of `generatePlan()`, `buildProteinSchedule()`, or any nutrition data.
- No change to Supabase integration, RLS-relevant logic, or the review consent model.
- No new medical claims, credentials, or statistics added anywhere.
