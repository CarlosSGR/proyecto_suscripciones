import SwiftUI

struct ContentView: View {
    @Environment(DivisasViewModel.self) private var divisas
    @AppStorage("tipoCambio") private var tipoCambio: Double = 18.5
    @AppStorage("fechaTipoCambio") private var fechaTipoCambio = ""

    var body: some View {
        TabView {
            Tab("Inicio", systemImage: "house.fill") {
                InicioView()
            }
            Tab("Suscripciones", systemImage: "list.bullet.rectangle") {
                SuscripcionesView()
            }
            Tab("Gráficas", systemImage: "chart.pie.fill") {
                GraficasView()
            }
            Tab("Ajustes", systemImage: "gearshape.fill") {
                AjustesView()
            }
        }
        .tint(Color(hex: "#5E5CE6"))
        .task {
            await divisas.obtenerTipoCambio()
            if let datos = divisas.tipoCambio {
                tipoCambio = datos.rates.MXN
                fechaTipoCambio = datos.date
            }
        }
    }
}
