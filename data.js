// Sample data. Swap for a real API (see README) once providers onboard.
window.HAULR = {
  services: {
    junk: {
      label: "Junk removal",
      sizeLabel: "How much stuff?",
      sizes: ["A few items", "1/4 truck", "1/2 truck", "3/4 truck", "Full truck"],
      base: [95, 179, 329, 449, 589],
    },
    moving: {
      label: "Moving",
      sizeLabel: "Size of the place",
      sizes: ["Studio", "1 bedroom", "2 bedroom", "3 bedroom", "4+ bedroom"],
      base: [349, 549, 899, 1399, 2099],
    },
    cleaning: {
      label: "Cleaning",
      sizeLabel: "Size of the place",
      sizes: ["Studio", "1 bedroom", "2 bedroom", "3 bedroom", "4+ bedroom"],
      base: [109, 139, 179, 239, 309],
    },
  },

  checks: [
    { key: "license", title: "License verified", body: "Checked against the state contractor / moving board (USDOT + MC number for movers), not a photo of a certificate." },
    { key: "insurance", title: "Insured, on file", body: "General liability and cargo coverage. We hold the certificate, and we get alerted when it lapses." },
    { key: "background", title: "Crew background checks", body: "Every person who walks into your home, not only the owner. Re-checked yearly." },
    { key: "reviews", title: "Booked-job reviews only", body: "You can only review a pro after a job paid through Haulr. No bought reviews, no review-for-discount." },
    { key: "pricing", title: "Price locked upfront", body: "The quote is the price. If the crew tries to upcharge on the day, we refund the difference." },
    { key: "disposal", title: "Responsible disposal", body: "Junk crews show dump and donation receipts. Your couch doesn't end up in a ditch with your name on it." },
  ],

  providers: [
    { id: 1, name: "Brick City Haulers", services: ["junk", "moving"], rating: 4.9, jobs: 1284, eta: 2, priceMult: 1.0, verified: ["license", "insurance", "background", "reviews", "pricing", "disposal"], years: 9, blurb: "Two-truck crew, same-day in Essex County. Donates usable furniture to local shelters." },
    { id: 2, name: "Clean Slate Co.", services: ["cleaning"], rating: 4.8, jobs: 902, eta: 24, priceMult: 0.95, verified: ["license", "insurance", "background", "reviews", "pricing"], years: 6, blurb: "Move-out and deep cleans. Bring-your-own-supplies option on request." },
    { id: 3, name: "Garden State Movers", services: ["moving"], rating: 4.7, jobs: 2210, eta: 48, priceMult: 1.12, verified: ["license", "insurance", "background", "reviews", "pricing"], years: 14, blurb: "USDOT 3381921. Interstate and local moves, piano and safe certified." },
    { id: 4, name: "Junk Jedis", services: ["junk"], rating: 4.6, jobs: 431, eta: 4, priceMult: 0.88, verified: ["license", "insurance", "reviews", "pricing", "disposal"], years: 3, blurb: "Cheapest per-load in the area. Background checks in progress for 2 new hires." },
    { id: 5, name: "Two Guys & A Van", services: ["junk", "moving"], rating: 4.2, jobs: 118, eta: 6, priceMult: 0.8, verified: ["license", "reviews"], years: 2, blurb: "Small jobs, fast. Insurance certificate pending re-upload." },
    { id: 6, name: "Spotless Squad", services: ["cleaning"], rating: 4.9, jobs: 1630, eta: 6, priceMult: 1.08, verified: ["license", "insurance", "background", "reviews", "pricing"], years: 8, blurb: "Same crew every visit for recurring cleans. Pet-safe products." },
    { id: 7, name: "Hudson Haul & Move", services: ["junk", "moving", "cleaning"], rating: 4.8, jobs: 760, eta: 24, priceMult: 1.05, verified: ["license", "insurance", "background", "reviews", "pricing", "disposal"], years: 11, blurb: "One crew for the whole move-out: haul the junk, move the rest, clean the empty place." },
  ],
};
