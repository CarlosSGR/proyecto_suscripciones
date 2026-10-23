import SwiftUI
import SwiftData

struct AgregarSuscripcionView: View {
    var viewModel: SuscripcionViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showAlert = false
    @State private var alerta: AlertaInfo?

    var body: some View {
        NavigationStack {
            Form {
                SuscripcionFormView(suscripcion: viewModel.borrador, viewModel: viewModel)
            }
            .navigationTitle("Nueva suscripción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        let resultado = viewModel.agregar(context: modelContext)
                        alerta = viewModel.alerta(for: resultado)
                        showAlert = true
                    }
                }
            }
            .alert(alerta?.titulo ?? "", isPresented: $showAlert) {
                Button("OK") {
                    if alerta?.titulo == "Operación exitosa" {
                        dismiss()
                    }
                }
            } message: {
                Text(alerta?.mensaje ?? "")
            }
        }
    }
}
