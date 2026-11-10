import SwiftUI
import SwiftData

@main
struct SuscripcionesApp: App {
    @State private var divisas = DivisasViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Suscripcion.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(divisas)
        }
        .modelContainer(sharedModelContainer)
    }
}
