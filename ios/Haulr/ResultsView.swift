import SwiftUI

struct ResultsView: View {
    @Environment(AppModel.self) private var model
    @State private var showCompare = false

    var body: some View {
        @Bindable var model = model
        List {
            Section {
                Picker("Sort", selection: $model.sort) {
                    ForEach(SortOrder.allCases) { Text($0.rawValue).tag($0) }
                }
                Toggle("Fully verified only", isOn: $model.onlyVerified)
            }

            Section {
                if model.results.isEmpty {
                    ContentUnavailableView(
                        "No fully verified pros yet",
                        systemImage: "checkmark.shield",
                        description: Text("Turn off \"Fully verified only\" to see crews still finishing their checks.")
                    )
                }
                ForEach(model.results) { p in
                    NavigationLink(value: p) { ProviderRow(provider: p) }
                        .swipeActions(edge: .leading) {
                            Button(model.compareIDs.contains(p.id) ? "Remove" : "Compare") {
                                model.toggleCompare(p)
                            }
                            .tint(.indigo)
                        }
                }
            } header: {
                Text("\(model.service.label) · \(model.service.sizes[model.sizeIndex])\(model.zip.isEmpty ? "" : " · \(model.zip)")")
            } footer: {
                Text("Swipe right on a pro to add it to compare.")
            }
        }
        .navigationTitle("Pros near you")
        .navigationDestination(for: Provider.self) { ProviderDetailView(provider: $0) }
        .safeAreaInset(edge: .bottom) {
            if model.compareIDs.count >= 2 {
                Button("Compare \(model.compareIDs.count) side by side") { showCompare = true }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.bottom, 8)
            }
        }
        .sheet(isPresented: $showCompare) { CompareView() }
    }
}

struct ProviderRow: View {
    @Environment(AppModel.self) private var model
    let provider: Provider

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            TrustBadge(score: provider.trustScore)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(provider.name).font(.headline)
                    if model.compareIDs.contains(provider.id) {
                        Image(systemName: "square.split.2x1.fill").foregroundStyle(.indigo)
                    }
                }
                Text("★ \(provider.rating, specifier: "%.1f") · \(provider.jobs) jobs · \(provider.years) yrs")
                    .font(.caption).foregroundStyle(.secondary)
                Text(provider.etaText).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(model.price(for: provider).dollars).font(.title3.bold())
                Text("locked").font(.caption2).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TrustBadge: View {
    let score: Int
    var size: CGFloat = 54

    private var color: Color { score >= 85 ? .green : score >= 70 ? .orange : .red }

    var body: some View {
        VStack(spacing: 0) {
            Text("\(score)").font(.system(size: size * 0.4, weight: .bold))
            Text("TRUST").font(.system(size: size * 0.14, weight: .semibold))
        }
        .foregroundStyle(.white)
        .frame(width: size, height: size)
        .background(color.gradient, in: .rect(cornerRadius: size * 0.22))
    }
}
