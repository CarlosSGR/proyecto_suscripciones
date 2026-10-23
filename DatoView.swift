import SwiftUI

struct DatoView: View {
    var titulo: String
    var valor: String

    var body: some View {
        HStack {
            Text(titulo)
                .foregroundColor(Color.secondary)
            Spacer()
            Text(valor)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    DatoView(titulo: "Precio", valor: "$299 MXN")
        .padding()
}
