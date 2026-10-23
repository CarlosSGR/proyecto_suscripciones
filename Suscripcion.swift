import Foundation
import SwiftData

@Model
final class Suscripcion {
    var nombre: String
    var precio: Double
    var moneda: String
    var diaCobro: Int
    var categoria: String

    init(nombre: String, precio: Double, moneda: String, diaCobro: Int, categoria: String) {
        self.nombre = nombre
        self.precio = precio
        self.moneda = moneda
        self.diaCobro = diaCobro
        self.categoria = categoria
    }
}
