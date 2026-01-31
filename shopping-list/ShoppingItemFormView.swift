//
//  ShoppingItemFormView.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/01/29.
//

import SwiftUI
import SwiftData

struct ShoppingItemFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String
    @State private var showingDeleteAlert = false
    
    var item: ShoppingItem?
    var shoppingList: ShoppingList
    
    // Initialize the view with the item to create or edit
    init(item: ShoppingItem? = nil, shoppingList: ShoppingList) {
        self.item = item
        self.shoppingList = shoppingList
        _name = State(initialValue: item?.name ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Details") {
                    TextField("Item Name", text: $name)
                }
                
                if item != nil {
                    Section {
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Delete Item")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(item == nil ? "Add Item" : "Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveItem()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .alert("Delete Item", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteItem()
                }
            } message: {
                Text("Are you sure you want to delete '\(item?.name ?? "this item")'? This action cannot be undone.")
            }
        }
    }
    
    // Saves an item to a list
    private func saveItem() {
        if let item = item {
            // Edit existing item
            item.name = name
        } else {
            // Create new item and associate with shopping list
            let newItem = ShoppingItem(name: name)
            newItem.list = shoppingList
            modelContext.insert(newItem)
        }
    }
    
    // Deletes an item from a list
    private func deleteItem() {
        guard let item = item else { return }
        modelContext.delete(item)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ShoppingList.self, configurations: config)
    
    let list = ShoppingList(name: "Groceries")
    container.mainContext.insert(list)
    
    return ShoppingItemFormView(shoppingList: list)
        .modelContainer(container)
}
