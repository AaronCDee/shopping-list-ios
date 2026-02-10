import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

@main
struct shopping_listApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var authService: AuthService
    @State private var syncService: FirestoreSyncService
    
    var sharedModelContainer: ModelContainer = {
        let schema             = Schema([ShoppingList.self, ShoppingItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        FirebaseApp.configure()

        let auth = AuthService()
        _authService = State(initialValue: auth)
        _syncService = State(initialValue: FirestoreSyncService(authService: auth))
        
        // Sign in immediately
        Task {
            try? await auth.signInAnonymously()
        }
    }

    var body: some Scene {
        WindowGroup {
            if authService.isSignedIn {
                ContentView(
                    authService: authService,
                    syncService: syncService
                )
            } else {
                ProgressView("Loading...")
                    .task {
                        do {
                           try await authService.signInAnonymously()
                       } catch {
                           print("Auth failed: \(error)")
                       }
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
