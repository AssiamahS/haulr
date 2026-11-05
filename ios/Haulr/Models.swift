import Foundation

enum ServiceType: String, CaseIterable, Identifiable, Codable {
    case junk, moving, cleaning
    var id: String { rawValue }

    var label: String {
        switch self {
        case .junk: "Junk removal"
        case .moving: "Moving"
        case .cleaning: "Cleaning"
        }
    }

    var symbol: String {
        switch self {
        case .junk: "trash"
        case .moving: "shippingbox"
        case .cleaning: "sparkles"
        }
    }

    var sizeLabel: String { self == .junk ? "How much stuff?" : "Size of the place" }

    var sizes: [String] {
        switch self {
        case .junk: ["A few items", "1/4 truck", "1/2 truck", "3/4 truck", "Full truck"]
        case .moving, .cleaning: ["Studio", "1 bedroom", "2 bedroom", "3 bedroom", "4+ bedroom"]
        }
    }

    /// Base price in dollars per size tier.
    var basePrices: [Double] {
        switch self {
        case .junk: [95, 179, 329, 449, 589]
        case .moving: [349, 549, 899, 1399, 2099]
        case .cleaning: [109, 139, 179, 239, 309]
        }
    }
}

enum CheckKind: String, CaseIterable, Identifiable, Codable {
    case license, insurance, background, reviews, pricing, disposal
    var id: String { rawValue }

    var title: String {
        switch self {
        case .license: "License verified"
        case .insurance: "Insured, on file"
        case .background: "Crew background checks"
        case .reviews: "Booked-job reviews only"
        case .pricing: "Price locked upfront"
        case .disposal: "Responsible disposal"
        }
    }

    var detail: String {
        switch self {
        case .license: "Checked against the state board (USDOT + MC number for movers), not a photo of a certificate."
        case .insurance: "General liability and cargo coverage. We hold the certificate and get alerted when it lapses."
        case .background: "Every person who walks into your home, not only the owner. Re-checked yearly."
        case .reviews: "You can only review a pro after a job paid through Haulr. No bought reviews."
        case .pricing: "The quote is the price. If the crew upcharges on the day, we refund the difference."
        case .disposal: "Junk crews show dump and donation receipts."
        }
    }

    var symbol: String {
        switch self {
        case .license: "checkmark.seal"
        case .insurance: "shield.lefthalf.filled"
        case .background: "person.badge.shield.checkmark"
        case .reviews: "star.bubble"
        case .pricing: "lock"
        case .disposal: "arrow.3.trianglepath"
        }
    }

    /// Disposal receipts only matter for junk jobs.
    static func relevant(to service: ServiceType) -> [CheckKind] {
        allCases.filter { $0 != .disposal || service == .junk }
    }
}

struct Provider: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let services: [ServiceType]
    let rating: Double
    let jobs: Int
    let etaHours: Int
    let priceMultiplier: Double
    let verified: Set<CheckKind>
    let years: Int
    let blurb: String

    /// 60 pts from checks, 30 from rating, 10 from track record.
    var trustScore: Int {
        let checks = Double(verified.count) / Double(CheckKind.allCases.count) * 60
        let rating = (rating - 3) / 2 * 30
        let volume = min(Double(jobs) / 1000, 1) * 10
        return max(0, Int((checks + rating + volume).rounded()))
    }

    func isFullyVerified(for service: ServiceType) -> Bool {
        CheckKind.relevant(to: service).allSatisfy(verified.contains)
    }

    func price(_ service: ServiceType, sizeIndex: Int) -> Double {
        service.basePrices[sizeIndex] * priceMultiplier
    }

    var etaText: String {
        if etaHours <= 6 { return "Today, ~\(etaHours)h" }
        if etaHours <= 24 { return "Tomorrow" }
        return "In \(etaHours / 24) days"
    }
}

struct Booking: Identifiable, Codable, Hashable {
    var id = UUID()
    let providerID: Int
    let providerName: String
    let service: ServiceType
    let sizeIndex: Int
    let date: Date
    let price: Double
    let name: String
    let phone: String
    let address: String
    let notes: String
    var status: Status = .confirmed

    enum Status: String, Codable {
        case confirmed, completed, cancelled
    }
}

extension Double {
    var dollars: String { formatted(.currency(code: "USD").precision(.fractionLength(0))) }
}
