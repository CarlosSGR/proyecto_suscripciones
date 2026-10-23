import SwiftUI
import SwiftData

struct EditarSuscripcionView: View {
    let item: Suscripcion

    @State private var viewModel = SuscripcionViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var draft = Suscripcion(nombre: "", precio: 0, moneda: "MXN", diaCobro: 1, categoria: "Streaming")

    @State private var showAlert = false
    @State private var alerta: AlertaInfo?

    var body: some View {
        Form {
            SuscripcionFormView(suscripcion: draft, viewModel: viewModel)

            Section {
                Button("Guardar cambios") {
                    let resultado = viewModel.actualizar(objetivo: item, desde: draft, context: modelContext)
                    alerta = viewModel.alerta(for: resultado)
                    showAlert = true
                }
            }
        }
        .navigationTitle("Editar")
        .onAppear {
            draft.nombre = item.nombre
            draft.precio = item.precio
            draft.moneda = item.moneda
            draft.diaCobro = item.diaCobro
            draft.categoria = item.categoria
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
