//
//  ShoppingListDetailView.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/01/31.
//

import SwiftUI
import SwiftData

struct ShoppingListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let shoppingList: ShoppingList
    
    @State private var showingAddSheet = false
    @State private var itemToEdit: ShoppingItem?
    
    private var items: [ShoppingItem] {
        shoppingList.items.sorted(by: { $0.addedAt > $1.addedAt })
    }

    var body: some View {
        Group {
            if items.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    Image(systemName: "cart")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text("No Items")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Button(action: { showingAddSheet = true }) {
                        Label("Add Item", systemImage: "plus")
                            .font(.headline)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                // List with items
                List {
                    ForEach(items) { item in
                        HStack {
                            // Checkbox
                            Button(action: {
                                withAnimation {
                                    item.isChecked.toggle()
                                    item.checkedAt = item.isChecked ? Date() : nil
                                }
                            }) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isChecked ? .green : .gray)
                                    .font(.title3)
                            }
                            .buttonStyle(.plain)
                            
                            // Item details
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                    .strikethrough(item.isChecked, color: .gray)
                                    .foregroundStyle(item.isChecked ? .secondary : .primary)
                                
                                Text(item.addedAt, format: Date.FormatStyle(date: .numeric, time: .standard))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteItem(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                itemToEdit = item
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle(shoppingList.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if items.count > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            ShoppingItemFormView(shoppingList: shoppingList)
        }
        .sheet(item: $itemToEdit) { item in
            ShoppingItemFormView(item: item, shoppingList: shoppingList)
        }
    }

    private func deleteItem(_ item: ShoppingItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ShoppingList.self, configurations: config)
    
    let list = ShoppingList(name: "Groceries")
    container.mainContext.insert(list)
    
    return NavigationStack {
        ShoppingListDetailView(shoppingList: list)
            .modelContainer(container)
    }
}
