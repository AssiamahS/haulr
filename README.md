# Haulr

Book junk removal, movers and cleaners the way you'd book a ride, except every crew is actually vetted.

## The problem

You search "junk removal near me" and get 10 lookalike sites that all say the same thing. Most people click the first ad. There's no way to tell who's licensed, insured, or going to upcharge you once your stuff is on the truck. Lead-gen sites (Angi, Thumbtack) sell your number to 5 companies and leave the vetting to you.

## The fix

- **Trust Score (0-100)**: 60 pts from six checks, 30 from rating, 10 from track record.
  1. License verified against the state board (USDOT/MC for movers)
  2. Insurance certificate on file, lapse alerts
  3. Background checks on the whole crew, not only the owner
  4. Reviews only from jobs booked and paid through Haulr
  5. Locked upfront price, Haulr refunds any day-of upcharge
  6. Dump/donation receipts for junk jobs
- **Instant price** from service + size, before anyone shows up.
- **Escrowed payment**: released after the customer marks the job done.
- **Pros pay 12% on completed jobs**, no lead fees.

## Run it

Static site, no build step.

```sh
python3 -m http.server 8080   # then open http://localhost:8080
```

## Deploy (Cloudflare Pages)

```sh
npx wrangler pages deploy . --project-name haulr
```

## Files

- `index.html`: page structure
- `styles.css`: styles
- `data.js`: sample services, pricing, checks and providers (replace with an API)
- `app.js`: search, Trust Score, sort/filter, compare, booking flow

## Next

- Real backend (Workers + D1): providers, bookings, reviews tied to booking IDs
- Pro onboarding: license lookup per state, insurance doc upload, Checkr for background checks
- Stripe Connect for escrow + payouts
- Photo-based estimates for junk jobs
