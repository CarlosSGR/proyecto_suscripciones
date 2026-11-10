import SwiftUI
import SwiftData

struct AjustesView: View {
    @AppStorage("nombreUsuario") private var nombreUsuario = ""
    @AppStorage("tipoCambio") private var tipoCambio: Double = 18.5
    @AppStorage("fechaTipoCambio") private var fechaTipoCambio = ""
    @AppStorage("diasAviso") private var diasAviso: Int = 3

    @Environment(\.modelContext) private var modelContext
    @Environment(DivisasViewModel.self) private var divisas
    @State private var viewModel = SuscripcionViewModel()
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Perfil") {
                    TextField("Tu nombre", text: $nombreUsuario)
                }

                Section("Tipo de cambio") {
                    HStack {
                        Text("1 USD =")
                        Spacer()
                        Text(viewModel.formatoDinero(tipoCambio) + " MXN")
                            .fontWeight(.bold)
                    }

                    if !fechaTipoCambio.isEmpty {
                        Text("Actualizado el \(fechaTipoCambio)")
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                    }

                    if divisas.cargando {
                        ProgressView()
                    } else {
                        Button {
                            Task {
                                await divisas.obtenerTipoCambio()
                                if let datos = divisas.tipoCambio {
                                    tipoCambio = datos.rates.MXN
                                    fechaTipoCambio = datos.date
                                }
                            }
                        } label: {
                            Label("Actualizar desde internet", systemImage: "arrow.clockwise")
                        }
                    }

                    if !divisas.mensajeError.isEmpty {
                        Text(divisas.mensajeError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Section("Escribir tipo de cambio a mano") {
                    TextField("Tipo de cambio", value: $tipoCambio, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section("Avisos de cobro") {
                    Stepper("Avisarme \(diasAviso) días antes", value: $diasAviso, in: 1...10)
                    Text("Las suscripciones que se cobren en ese plazo aparecen marcadas en Inicio.")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
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
        .environment(DivisasViewModel())
}
