import SwiftUI
import SwiftData
import Charts

struct GraficasView: View {
    @Query(sort: \Suscripcion.diaCobro) private var suscripciones: [Suscripcion]
    @State private var viewModel = SuscripcionViewModel()
    @AppStorage("tipoCambio") private var tipoCambio: Double = 18.5

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    if suscripciones.isEmpty {
                        Text("Agrega suscripciones para ver tus gráficas.")
                            .foregroundColor(Color.secondary)
                    } else {

                        Text("Gasto por categoría")
                            .font(.title3)
                            .fontWeight(.bold)

                        Chart(viewModel.totalPorCategoria(suscripciones, tipoCambio: tipoCambio), id: \.0) { dato in
                            SectorMark(
                                angle: .value("Gasto", dato.1),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.5
                            )
                            .foregroundStyle(dato.2)
                        }
                        .frame(height: 250)

                        VStack(spacing: 10) {
                            ForEach(viewModel.totalPorCategoria(suscripciones, tipoCambio: tipoCambio), id: \.0) { dato in
                                HStack {
                                    Circle()
                                        .fill(dato.2)
                                        .frame(width: 12, height: 12)
                                    Text(dato.0)
                                    Spacer()
                                    Text(viewModel.formatoDinero(dato.1) + " MXN")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .modifier(CardModifier())

                        Text("Gasto mensual por suscripción (MXN)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)

                        Chart {
                            ForEach(suscripciones) { suscripcion in
                                BarMark(
                                    x: .value("Suscripción", suscripcion.nombre),
                                    y: .value("MXN", viewModel.precioEnPesos(suscripcion, tipoCambio: tipoCambio))
                                )
                                .foregroundStyle(viewModel.color(for: suscripcion.categoria))
                            }
                        }
                        .frame(height: 300)
                    }
                }
                .padding()
            }
            .navigationTitle("Gráficas")
        }
    }
}
