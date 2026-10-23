import SwiftUI

struct ContentView: View {
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
    }
}
