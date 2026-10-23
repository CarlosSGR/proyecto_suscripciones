import SwiftUI
import SwiftData

struct InicioView: View {
    @Query(sort: \Suscripcion.diaCobro) private var suscripciones: [Suscripcion]
    @State private var viewModel = SuscripcionViewModel()

    @AppStorage("nombreUsuario") private var nombreUsuario = ""
    @AppStorage("tipoCambio") private var tipoCambio: Double = 18.5

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text(nombreUsuario.isEmpty ? "¡Hola!" : "¡Hola, \(nombreUsuario)!")
                        .font(.title2)
                        .fontWeight(.bold)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gasto mensual")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(viewModel.formatoDinero(viewModel.totalMensual(suscripciones, tipoCambio: tipoCambio)) + " MXN")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("\(suscripciones.count) suscripciones activas")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#5E5CE6"), Color(hex: "#BF5AF2")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)

                    Text("Próximos cobros")
                        .font(.title3)
                        .fontWeight(.bold)

                    if suscripciones.isEmpty {
                        Text("Aún no tienes suscripciones. Agrega una en la pestaña Suscripciones o carga ejemplos en Ajustes.")
                            .foregroundColor(Color.secondary)
                    }

                    ForEach(suscripciones) { suscripcion in
                        SuscripcionRowView(suscripcion: suscripcion, viewModel: viewModel)
                            .modifier(CardModifier())
                    }
                }
                .padding()
            }
            .navigationTitle("Mis Suscripciones")
        }
    }
}
