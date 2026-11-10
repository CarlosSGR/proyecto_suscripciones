import Foundation
import Observation

@MainActor
@Observable
final class DivisasViewModel {
    var tipoCambio: TipoCambio?
    var cargando = false
    var mensajeError = ""

    func obtenerTipoCambio() async {
        let endPoint = "https://api.frankfurter.dev/v1/latest?base=USD&symbols=MXN"
        guard let apiURL = URL(string: endPoint) else {
            mensajeError = "URL no válida."
            return
        }

        var urlRequest = URLRequest(url: apiURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        cargando = true
        mensajeError = ""

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                mensajeError = "Sin respuesta del servidor."
                cargando = false
                return
            }
            guard httpResponse.statusCode == 200 else {
                mensajeError = "Error del servidor: \(httpResponse.statusCode)"
                cargando = false
                return
            }

            let decoded = try JSONDecoder().decode(TipoCambio.self, from: data)
            tipoCambio = decoded
        } catch {
            mensajeError = "Sin conexión. Se usa el último tipo de cambio guardado."
        }
        cargando = false
    }
}
