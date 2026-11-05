import SwiftUI

struct BookView: View {
    @Environment(AppModel.self) private var model
    @State private var showResults = false

    var body: some View {
        @Bindable var model = model
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Stop clicking the first ad.")
                        .font(.largeTitle.bold())
                    Text("Book a crew that's actually vetted.")
                        .font(.title2.bold())
                        .foregroundStyle(.tint)
                    Text("Licensed, insured, background-checked. Reviews only from real jobs. Price before anyone shows up.")
                        .foregroundStyle(.secondary)
                }

                Picker("Service", selection: $model.service) {
                    ForEach(ServiceType.allCases) { s in
                        Label(s.label, systemImage: s.symbol).tag(s)
                    }
                }
                .pickerStyle(.segmented)

                VStack(alignment: .leading, spacing: 14) {
                    TextField("ZIP code", text: $model.zip)
                        .keyboardType(.numberPad)
                        .textContentType(.postalCode)
                        .padding(12)
                        .background(.background, in: .rect(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(model.service.sizeLabel).font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(model.service.sizes[model.sizeIndex]).foregroundStyle(.secondary)
                        }
                        Slider(value: Binding(
                            get: { Double(model.sizeIndex) },
                            set: { model.sizeIndex = Int($0.rounded()) }
                        ), in: 0...4, step: 1)
                    }

                    DatePicker("When", selection: $model.date, in: Date.now..., displayedComponents: .date)
                        .font(.subheadline.weight(.semibold))
                }
                .padding()
                .background(.quaternary.opacity(0.5), in: .rect(cornerRadius: 16))

                HStack {
                    Text("Typical price")
                    Spacer()
                    Text(model.estimateRange).bold()
                }
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: 14))

                Button {
                    showResults = true
                } label: {
                    Text("Find vetted pros")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
        .navigationTitle("haulr")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showResults) { ResultsView() }
        .scrollDismissesKeyboard(.interactively)
    }
}
