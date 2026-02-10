//
//  ShoppingListFormView.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/01/31.
//

import SwiftUI
import SwiftData

struct ShoppingListFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let shoppingList: ShoppingList?
    let authService: AuthService
    let syncService: FirestoreSyncService
    
    @State private var name: String = ""
    
    init(shoppingList: ShoppingList? = nil, authService: AuthService, syncService: FirestoreSyncService) {
        self.shoppingList = shoppingList
        self.authService = authService
        self.syncService = syncService
        _name = State(initialValue: shoppingList?.name ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("List Name", text: $name)
                }
            }
            .navigationTitle(shoppingList == nil ? "New List" : "Edit List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func save() {
        let listToSync: ShoppingList
        
        if let shoppingList {
            shoppingList.name = name
            listToSync = shoppingList
        } else {
            let newList = ShoppingList(name: name)
            newList.ownerId = authService.userId
            modelContext.insert(newList)
            listToSync = newList
        }
        
        // Sync to Firestore in the background
        Task {
            do {
                try await syncService.sync(listToSync)
            } catch {
                print("Firestore sync failed: \(error.localizedDescription)")
            }
        }
        
        dismiss()
    }
}

#Preview {
    ShoppingListFormView(
        authService: AuthService(),
        syncService: FirestoreSyncService(authService: AuthService())
    )
    .modelContainer(for: ShoppingList.self, inMemory: true)
}
