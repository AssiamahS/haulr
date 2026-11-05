import SwiftUI

struct ProviderDetailView: View {
    @Environment(AppModel.self) private var model
    let provider: Provider
    @State private var showBooking = false

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    TrustBadge(score: provider.trustScore, size: 72)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(provider.name).font(.title2.bold())
                        Text("★ \(provider.rating, specifier: "%.1f") · \(provider.jobs) booked jobs")
                            .foregroundStyle(.secondary)
                        Text("\(provider.years) years in business").foregroundStyle(.secondary)
                    }
                }
                Text(provider.blurb)
            }

            Section("Verification") {
                ForEach(CheckKind.relevant(to: model.service)) { check in
                    let ok = provider.verified.contains(check)
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(check.title).strikethrough(!ok).foregroundStyle(ok ? .primary : .secondary)
                            Text(ok ? check.detail : "Not yet verified").font(.caption).foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: ok ? "checkmark.circle.fill" : "minus.circle")
                            .foregroundStyle(ok ? .green : .secondary)
                    }
                }
            }

            Section("Your job") {
                LabeledContent("Service", value: model.service.label)
                LabeledContent("Size", value: model.service.sizes[model.sizeIndex])
                LabeledContent("Date", value: model.date.formatted(date: .abbreviated, time: .omitted))
                LabeledContent("Arrival", value: provider.etaText)
                LabeledContent("Locked price") { Text(model.price(for: provider).dollars).bold() }
            }
        }
        .navigationTitle(provider.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(model.compareIDs.contains(provider.id) ? "Comparing" : "Compare") {
                    model.toggleCompare(provider)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showBooking = true
            } label: {
                Text("Book for \(model.price(for: provider).dollars)")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
        }
        .sheet(isPresented: $showBooking) { BookingSheet(provider: provider) }
    }
}
