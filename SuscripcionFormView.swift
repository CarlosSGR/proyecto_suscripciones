import SwiftUI

struct SuscripcionFormView: View {
    @Bindable var suscripcion: Suscripcion
    var viewModel: SuscripcionViewModel

    var body: some View {
        Section("Datos") {
            TextField("Nombre (ej. Netflix)", text: $suscripcion.nombre)
            TextField("Precio", value: $suscripcion.precio, format: .number)
                .keyboardType(.decimalPad)
            Picker("Moneda", selection: $suscripcion.moneda) {
                ForEach(viewModel.monedas, id: \.self) { moneda in
                    Text(moneda)
                }
            }
        }

        Section("Cobro") {
            Stepper("Se cobra el día \(suscripcion.diaCobro)", value: $suscripcion.diaCobro, in: 1...31)
        }

        Section("Categoría") {
            Picker("Categoría", selection: $suscripcion.categoria) {
                ForEach(viewModel.categorias, id: \.self) { categoria in
                    Label(categoria, systemImage: viewModel.icono(for: categoria))
                }
            }
        }
    }
}

#Preview {
    Form {
        SuscripcionFormView(suscripcion: SuscripcionViewModel().ejemplos()[0], viewModel: SuscripcionViewModel())
    }
}
