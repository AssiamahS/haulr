import Foundation

/// Sample providers. Mirrors web/data.js until there's a real API.
enum Catalog {
    static let providers: [Provider] = [
        Provider(id: 1, name: "Brick City Haulers", services: [.junk, .moving], rating: 4.9, jobs: 1284, etaHours: 2, priceMultiplier: 1.0,
                 verified: Set(CheckKind.allCases), years: 9,
                 blurb: "Two-truck crew, same-day in Essex County. Donates usable furniture to local shelters."),
        Provider(id: 2, name: "Clean Slate Co.", services: [.cleaning], rating: 4.8, jobs: 902, etaHours: 24, priceMultiplier: 0.95,
                 verified: [.license, .insurance, .background, .reviews, .pricing], years: 6,
                 blurb: "Move-out and deep cleans. Bring-your-own-supplies option on request."),
        Provider(id: 3, name: "Garden State Movers", services: [.moving], rating: 4.7, jobs: 2210, etaHours: 48, priceMultiplier: 1.12,
                 verified: [.license, .insurance, .background, .reviews, .pricing], years: 14,
                 blurb: "USDOT 3381921. Interstate and local moves, piano and safe certified."),
        Provider(id: 4, name: "Junk Jedis", services: [.junk], rating: 4.6, jobs: 431, etaHours: 4, priceMultiplier: 0.88,
                 verified: [.license, .insurance, .reviews, .pricing, .disposal], years: 3,
                 blurb: "Cheapest per-load in the area. Background checks in progress for 2 new hires."),
        Provider(id: 5, name: "Two Guys & A Van", services: [.junk, .moving], rating: 4.2, jobs: 118, etaHours: 6, priceMultiplier: 0.8,
                 verified: [.license, .reviews], years: 2,
                 blurb: "Small jobs, fast. Insurance certificate pending re-upload."),
        Provider(id: 6, name: "Spotless Squad", services: [.cleaning], rating: 4.9, jobs: 1630, etaHours: 6, priceMultiplier: 1.08,
                 verified: [.license, .insurance, .background, .reviews, .pricing], years: 8,
                 blurb: "Same crew every visit for recurring cleans. Pet-safe products."),
        Provider(id: 7, name: "Hudson Haul & Move", services: [.junk, .moving, .cleaning], rating: 4.8, jobs: 760, etaHours: 24, priceMultiplier: 1.05,
                 verified: Set(CheckKind.allCases), years: 11,
                 blurb: "One crew for the whole move-out: haul the junk, move the rest, clean the empty place."),
    ]
}
