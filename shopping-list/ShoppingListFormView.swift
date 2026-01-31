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
    
    @State private var name: String = ""
    
    init(shoppingList: ShoppingList? = nil) {
        self.shoppingList = shoppingList
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
        if let shoppingList {
            // Edit existing list
            shoppingList.name = name
        } else {
            // Create new list
            let newList = ShoppingList(name: name)
            modelContext.insert(newList)
        }
        
        dismiss()
    }
}

#Preview {
    ShoppingListFormView()
        .modelContainer(for: ShoppingList.self, inMemory: true)
}
