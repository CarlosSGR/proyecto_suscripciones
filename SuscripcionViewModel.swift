import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable class SuscripcionViewModel {
    var borrador: Suscripcion
    var searchText = ""

    let monedas: [String] = ["MXN", "USD"]
    let categorias: [String] = ["Streaming", "Música", "Videojuegos", "Software", "Otros"]

    init() {
        borrador = Suscripcion(nombre: "", precio: 0, moneda: "MXN", diaCobro: 1, categoria: "Streaming")
    }

    func ejemplos() -> [Suscripcion] {
        return [
            Suscripcion(nombre: "Netflix", precio: 299, moneda: "MXN", diaCobro: 5, categoria: "Streaming"),
            Suscripcion(nombre: "Spotify", precio: 129, moneda: "MXN", diaCobro: 12, categoria: "Música"),
            Suscripcion(nombre: "ChatGPT Plus", precio: 20, moneda: "USD", diaCobro: 18, categoria: "Software"),
            Suscripcion(nombre: "Xbox Game Pass", precio: 249, moneda: "MXN", diaCobro: 22, categoria: "Videojuegos"),
            Suscripcion(nombre: "iCloud+", precio: 2.99, moneda: "USD", diaCobro: 28, categoria: "Software")
        ]
    }

    func cargarEjemplos(context: ModelContext) {
        for suscripcion in ejemplos() {
            context.insert(suscripcion)
        }
        try? context.save()
    }

    func icono(for categoria: String) -> String {
        switch categoria {
        case "Streaming":
            return "play.tv.fill"
        case "Música":
            return "music.note"
        case "Videojuegos":
            return "gamecontroller.fill"
        case "Software":
            return "laptopcomputer"
        default:
            return "creditcard.fill"
        }
    }

    func color(for categoria: String) -> Color {
        switch categoria {
        case "Streaming":
            return Color(hex: "#E50914")
        case "Música":
            return Color(hex: "#1DB954")
        case "Videojuegos":
            return Color(hex: "#107C10")
        case "Software":
            return Color(hex: "#0A84FF")
        default:
            return Color(hex: "#8E8E93")
        }
    }

    func formatoDinero(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let formatted = formatter.string(from: NSNumber(value: valor)) {
            return "$" + formatted
        } else {
            return "$" + String(valor)
        }
    }

    func precioEnPesos(_ suscripcion: Suscripcion, tipoCambio: Double) -> Double {
        if suscripcion.moneda == "USD" {
            return suscripcion.precio * tipoCambio
        }
        return suscripcion.precio
    }

    func totalMensual(_ suscripciones: [Suscripcion], tipoCambio: Double) -> Double {
        var total: Double = 0
        for suscripcion in suscripciones {
            total += precioEnPesos(suscripcion, tipoCambio: tipoCambio)
        }
        return total
    }

    func totalPorCategoria(_ suscripciones: [Suscripcion], tipoCambio: Double) -> [(String, Double, Color)] {
        var datos: [(String, Double, Color)] = []
        for categoria in categorias {
            var total: Double = 0
            for suscripcion in suscripciones {
                if suscripcion.categoria == categoria {
                    total += precioEnPesos(suscripcion, tipoCambio: tipoCambio)
                }
            }
            if total > 0 {
                datos.append((categoria, total, color(for: categoria)))
            }
        }
        return datos
    }

    func filtradas(from suscripciones: [Suscripcion]) -> [Suscripcion] {
        let search = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !search.isEmpty else { return suscripciones }
        return suscripciones.filter {
            $0.nombre.localizedCaseInsensitiveContains(search)
        }
    }

    private func validar(_ suscripcion: Suscripcion)
        -> (nombre: String, precio: Double, moneda: String, diaCobro: Int, categoria: String)? {
        let nombre = suscripcion.nombre
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nombre.isEmpty,
              suscripcion.precio > 0,
              suscripcion.diaCobro >= 1,
              suscripcion.diaCobro <= 31
        else {
            return nil
        }
        return (nombre: nombre,
                precio: suscripcion.precio,
                moneda: suscripcion.moneda,
                diaCobro: suscripcion.diaCobro,
                categoria: suscripcion.categoria)
    }

    func agregar(context: ModelContext) -> ResultadoOperacion {
        guard let datos = validar(borrador) else {
            return .datosInvalidos
        }
        let nueva = Suscripcion(
            nombre: datos.nombre,
            precio: datos.precio,
            moneda: datos.moneda,
            diaCobro: datos.diaCobro,
            categoria: datos.categoria
        )
        context.insert(nueva)
        do {
            try context.save()
            borrador.nombre = ""
            borrador.precio = 0
            borrador.moneda = "MXN"
            borrador.diaCobro = 1
            borrador.categoria = "Streaming"
            return .exito
        } catch {
            return .errorGuardar
        }
    }

    func actualizar(objetivo: Suscripcion, desde draft: Suscripcion, context: ModelContext) -> ResultadoOperacion {
        guard let datos = validar(draft) else {
            return .datosInvalidos
        }
        objetivo.nombre = datos.nombre
        objetivo.precio = datos.precio
        objetivo.moneda = datos.moneda
        objetivo.diaCobro = datos.diaCobro
        objetivo.categoria = datos.categoria
        do {
            try context.save()
            return .exito
        } catch {
            return .errorGuardar
        }
    }

    func borrar(offsets: IndexSet, suscripciones: [Suscripcion], context: ModelContext) {
        for index in offsets {
            guard suscripciones.indices.contains(index) else { continue }
            context.delete(suscripciones[index])
        }
        try? context.save()
    }

    func alerta(for resultado: ResultadoOperacion) -> AlertaInfo {
        switch resultado {
        case .exito:
            return AlertaInfo(
                titulo: "Operación exitosa",
                mensaje: "Los cambios se guardaron correctamente.")
        case .datosInvalidos:
            return AlertaInfo(
                titulo: "Datos inválidos",
                mensaje: "Escribe un nombre y un precio mayor a 0.")
        case .errorGuardar:
            return AlertaInfo(
                titulo: "Error",
                mensaje: "No se pudieron guardar los cambios.")
        }
    }
}
