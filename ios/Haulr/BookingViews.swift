import SwiftUI

struct BookingSheet: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let provider: Provider

    @State private var name = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var notes = ""
    @State private var confirmed = false

    private var valid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && phone.filter(\.isNumber).count >= 10
            && !address.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            if confirmed {
                ContentUnavailableView {
                    Label("You're booked", systemImage: "checkmark.circle.fill")
                } description: {
                    Text("\(provider.name) will confirm within 15 minutes. Payment is held by Haulr and released only after you mark the job done.")
                } actions: {
                    Button("Done") { dismiss() }.buttonStyle(.borderedProminent)
                }
            } else {
                Form {
                    Section {
                        LabeledContent("Locked price") { Text(model.price(for: provider).dollars).font(.title3.bold()) }
                        Text("If the crew asks for more on the day, Haulr refunds the difference.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Section("Contact") {
                        TextField("Full name", text: $name).textContentType(.name)
                        TextField("Phone", text: $phone).keyboardType(.phonePad).textContentType(.telephoneNumber)
                        TextField("Street address", text: $address).textContentType(.fullStreetAddress)
                    }
                    Section("Notes for the crew") {
                        TextField("Stairs, parking, heavy items…", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                .navigationTitle("Book \(provider.name)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Confirm") {
                            model.book(provider, name: name, phone: phone, address: address, notes: notes)
                            withAnimation { confirmed = true }
                        }
                        .disabled(!valid)
                    }
                }
            }
        }
    }
}

struct BookingsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        List {
            if model.bookings.isEmpty {
                ContentUnavailableView("No bookings yet", systemImage: "calendar",
                                       description: Text("Book a vetted pro from the Book tab."))
            }
            ForEach(model.bookings) { b in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(b.providerName).font(.headline)
                        Spacer()
                        Text(b.price.dollars).bold()
                    }
                    Text("\(b.service.label) · \(b.service.sizes[b.sizeIndex]) · \(b.date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption).foregroundStyle(.secondary)
                    Text(statusText(b.status))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(statusColor(b.status))
                }
                .swipeActions {
                    if b.status == .confirmed {
                        Button("Job done") { model.setStatus(.completed, for: b) }.tint(.green)
                        Button("Cancel", role: .destructive) { model.setStatus(.cancelled, for: b) }
                    }
                }
            }
        }
        .navigationTitle("Bookings")
    }

    private func statusText(_ s: Booking.Status) -> String {
        switch s {
        case .confirmed: "Confirmed · payment held"
        case .completed: "Done · payment released"
        case .cancelled: "Cancelled · refunded"
        }
    }

    private func statusColor(_ s: Booking.Status) -> Color {
        switch s {
        case .confirmed: .orange
        case .completed: .green
        case .cancelled: .secondary
        }
    }
}
