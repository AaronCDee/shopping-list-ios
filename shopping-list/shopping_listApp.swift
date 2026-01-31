//
//  shopping_listApp.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/01/29.
//

import SwiftUI
import SwiftData

@main
struct shopping_listApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema             = Schema([ShoppingList.self, ShoppingItem.self])
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
        }
        .modelContainer(sharedModelContainer)
    }
}
