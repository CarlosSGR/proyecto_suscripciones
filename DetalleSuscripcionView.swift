import SwiftUI

struct DetalleSuscripcionView: View {
    let suscripcion: Suscripcion
    @State private var viewModel = SuscripcionViewModel()
    @AppStorage("tipoCambio") private var tipoCambio: Double = 18.5

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(viewModel.color(for: suscripcion.categoria))
                        .frame(width: 100, height: 100)
                    Image(systemName: viewModel.icono(for: suscripcion.categoria))
                        .font(.system(size: 45))
                        .foregroundColor(.white)
                }

                Text(suscripcion.nombre)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(suscripcion.categoria)
                    .font(.caption)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .overlay(
                        Capsule()
                            .stroke(viewModel.color(for: suscripcion.categoria), lineWidth: 2)
                    )

                VStack(spacing: 14) {
                    DatoView(titulo: "Precio", valor: viewModel.formatoDinero(suscripcion.precio) + " " + suscripcion.moneda)

                    if suscripcion.moneda == "USD" {
                        DatoView(titulo: "En pesos (aprox.)", valor: viewModel.formatoDinero(viewModel.precioEnPesos(suscripcion, tipoCambio: tipoCambio)) + " MXN")
                    }

                    DatoView(titulo: "Día de cobro", valor: "\(suscripcion.diaCobro) de cada mes")

                    DatoView(titulo: "Gasto al año", valor: viewModel.formatoDinero(viewModel.precioEnPesos(suscripcion, tipoCambio: tipoCambio) * 12) + " MXN")
                }
                .modifier(CardModifier())
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditarSuscripcionView(item: suscripcion)) {
                    Text("Editar")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetalleSuscripcionView(suscripcion: SuscripcionViewModel().ejemplos()[2])
    }
}
