import SwiftUI
import SwiftData

struct AjustesView: View {
    @AppStorage("nombreUsuario") private var nombreUsuario = ""
    @AppStorage("tipoCambio") private var tipoCambio: Double = 18.5
    @AppStorage("diasAviso") private var diasAviso: Int = 3

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SuscripcionViewModel()
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Perfil") {
                    TextField("Tu nombre", text: $nombreUsuario)
                }

                Section("Tipo de cambio (1 USD en MXN)") {
                    TextField("Tipo de cambio", value: $tipoCambio, format: .number)
                        .keyboardType(.decimalPad)
                    Text("Se usa para convertir a pesos las suscripciones en dólares.")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                }

                Section("Avisos de cobro") {
                    Stepper("Avisarme \(diasAviso) días antes", value: $diasAviso, in: 1...10)
                }

                Section("Datos de prueba") {
                    Button("Cargar suscripciones de ejemplo") {
                        viewModel.cargarEjemplos(context: modelContext)
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Ajustes")
            .alert("Listo", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text("Se agregaron 5 suscripciones de ejemplo.")
            }
        }
    }
}

#Preview {
    AjustesView()
}
