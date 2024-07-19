import SwiftUI
import SwiftData

@main
struct AIMacroAssistantApp: App {
    
    @StateObject private var macroManager = MacroManager()
    @AppStorage("shouldShowOnboarding") private var shouldShowOnboarding = true
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Macro.self,
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
            if shouldShowOnboarding {
                OnBoardingView(shoulShowOnboarding: $shouldShowOnboarding)
                    .environmentObject(macroManager)
                    .modelContainer(sharedModelContainer)
            } else {
                MainView()
                    .environmentObject(macroManager)
                    .modelContainer(sharedModelContainer)
            }
        }
    }
}
