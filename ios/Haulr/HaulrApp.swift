import SwiftUI

@main
struct HaulrApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(model)
        }
    }
}

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Book", systemImage: "magnifyingglass") {
                NavigationStack { BookView() }
            }
            Tab("Bookings", systemImage: "calendar") {
                NavigationStack { BookingsView() }
            }
            Tab("How we vet", systemImage: "checkmark.shield") {
                NavigationStack { VettingView() }
            }
            Tab("For pros", systemImage: "person.2") {
                NavigationStack { ForProsView() }
            }
        }
    }
}
