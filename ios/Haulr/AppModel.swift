import Foundation
import Observation

enum SortOrder: String, CaseIterable, Identifiable {
    case trust = "Trust Score"
    case price = "Lowest price"
    case eta = "Soonest"
    var id: String { rawValue }
}

@Observable
final class AppModel {
    // search
    var service: ServiceType = .junk
    var sizeIndex = 1
    var zip = ""
    var date = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now

    // results
    var sort: SortOrder = .trust
    var onlyVerified = true
    var compareIDs: Set<Int> = []

    // bookings, persisted
    private(set) var bookings: [Booking] = []
    private let storeKey = "haulr.bookings.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: storeKey),
           let saved = try? JSONDecoder().decode([Booking].self, from: data) {
            bookings = saved
        }
    }

    var estimateRange: String {
        let base = service.basePrices[sizeIndex]
        return "\((base * 0.85).dollars) – \((base * 1.15).dollars)"
    }

    var results: [Provider] {
        var list = Catalog.providers.filter { $0.services.contains(service) }
        if onlyVerified { list = list.filter { $0.isFullyVerified(for: service) } }
        switch sort {
        case .trust: list.sort { $0.trustScore > $1.trustScore }
        case .price: list.sort { $0.priceMultiplier < $1.priceMultiplier }
        case .eta: list.sort { $0.etaHours < $1.etaHours }
        }
        return list
    }

    var compared: [Provider] { Catalog.providers.filter { compareIDs.contains($0.id) } }

    func toggleCompare(_ p: Provider) {
        if compareIDs.contains(p.id) { compareIDs.remove(p.id) } else { compareIDs.insert(p.id) }
    }

    func price(for p: Provider) -> Double { p.price(service, sizeIndex: sizeIndex) }

    @discardableResult
    func book(_ p: Provider, name: String, phone: String, address: String, notes: String) -> Booking {
        let booking = Booking(providerID: p.id, providerName: p.name, service: service, sizeIndex: sizeIndex,
                              date: date, price: price(for: p), name: name, phone: phone, address: address, notes: notes)
        bookings.insert(booking, at: 0)
        save()
        return booking
    }

    func setStatus(_ status: Booking.Status, for booking: Booking) {
        guard let i = bookings.firstIndex(where: { $0.id == booking.id }) else { return }
        bookings[i].status = status
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }
}
