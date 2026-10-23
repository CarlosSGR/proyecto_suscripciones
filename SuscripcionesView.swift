import SwiftUI
import SwiftData

struct SuscripcionesView: View {
    @State private var viewModel = SuscripcionViewModel()
    @Query(sort: \Suscripcion.diaCobro) private var suscripciones: [Suscripcion]
    @Environment(\.modelContext) private var modelContext

    @State private var mostrarAgregar = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filtradas(from: suscripciones)) { suscripcion in
                    NavigationLink(destination: DetalleSuscripcionView(suscripcion: suscripcion)) {
                        SuscripcionRowView(suscripcion: suscripcion, viewModel: viewModel)
                    }
                }
                .onDelete { offsets in
                    let filtradas = viewModel.filtradas(from: suscripciones)
                    viewModel.borrar(offsets: offsets, suscripciones: filtradas, context: modelContext)
                }
            }
            .navigationTitle("Suscripciones")
            .searchable(text: $viewModel.searchText, prompt: "Buscar suscripción")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarAgregar = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $mostrarAgregar) {
                AgregarSuscripcionView(viewModel: viewModel)
            }
        }
    }
}
