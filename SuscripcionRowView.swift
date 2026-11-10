import SwiftUI

struct SuscripcionRowView: View {
    var suscripcion: Suscripcion
    var viewModel: SuscripcionViewModel
    @AppStorage("diasAviso") private var diasAviso: Int = 3

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(viewModel.color(for: suscripcion.categoria))
                    .frame(width: 45, height: 45)
                Image(systemName: viewModel.icono(for: suscripcion.categoria))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading) {
                Text(suscripcion.nombre)
                    .font(.headline)
                Text(suscripcion.categoria)
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(viewModel.formatoDinero(suscripcion.precio) + " " + suscripcion.moneda)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(viewModel.textoCobro(suscripcion))
                    .font(.caption)
                    .fontWeight(viewModel.diasParaCobro(suscripcion) <= diasAviso ? .bold : .regular)
                    .foregroundColor(viewModel.diasParaCobro(suscripcion) <= diasAviso ? Color.red : Color.secondary)
            }
        }
    }
}

#Preview {
    SuscripcionRowView(suscripcion: SuscripcionViewModel().ejemplos()[0], viewModel: SuscripcionViewModel())
        .padding()
}
