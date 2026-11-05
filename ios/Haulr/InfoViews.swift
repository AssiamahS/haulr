import SwiftUI

struct CompareView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                row("Trust Score") { "\($0.trustScore)" }
                row("Locked price") { model.price(for: $0).dollars }
                row("Arrival") { $0.etaText }
                row("Rating") { String(format: "★ %.1f", $0.rating) }
                row("Booked jobs") { "\($0.jobs)" }
                ForEach(CheckKind.relevant(to: model.service)) { check in
                    row(check.title) { $0.verified.contains(check) ? "✓" : "–" }
                }
            }
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") { model.compareIDs.removeAll(); dismiss() }
                }
            }
        }
    }

    private func row(_ label: String, _ value: @escaping (Provider) -> String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            HStack {
                ForEach(model.compared) { p in
                    VStack(spacing: 2) {
                        Text(value(p)).font(.subheadline.weight(.semibold))
                        Text(p.name).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct VettingView: View {
    var body: some View {
        List {
            Section {
                Text("Anyone can buy a Google ad. Getting on Haulr takes six checks, re-run every 90 days.")
            }
            Section("The Trust Score") {
                ForEach(CheckKind.allCases) { check in
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(check.title).font(.headline)
                            Text(check.detail).font(.subheadline).foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: check.symbol).foregroundStyle(.tint)
                    }
                    .padding(.vertical, 4)
                }
            }
            Section("How it adds up") {
                LabeledContent("Six checks", value: "60 pts")
                LabeledContent("Customer rating", value: "30 pts")
                LabeledContent("Track record", value: "10 pts")
            }
        }
        .navigationTitle("How we vet")
    }
}

struct ForProsView: View {
    @State private var business = ""
    @State private var license = ""
    @State private var email = ""
    @State private var submitted = false

    var body: some View {
        Form {
            Section {
                Text("Stop paying $80 a lead to be one of six companies that get the same call. On Haulr you get booked jobs with the price already agreed.")
                Label("No lead fees. 12% only on completed jobs.", systemImage: "dollarsign.circle")
                Label("Next-day payouts.", systemImage: "banknote")
                Label("Portable Trust Score badge for your own site.", systemImage: "checkmark.seal")
            }
            Section("Apply") {
                TextField("Business name", text: $business)
                TextField("State license # / USDOT #", text: $license)
                TextField("Email", text: $email).keyboardType(.emailAddress).textInputAutocapitalization(.never)
                Button("Apply to join") { submitted = true }
                    .disabled(business.isEmpty || license.isEmpty || !email.contains("@"))
            }
            if submitted {
                Section {
                    Text("Got it. We'll email you the verification checklist within one business day.")
                        .foregroundStyle(.green)
                }
            }
        }
        .navigationTitle("For pros")
    }
}
