import Foundation

struct TipoCambio: Decodable {
    let base: String
    let date: String
    let rates: Rates

    struct Rates: Decodable {
        let MXN: Double
    }
}
