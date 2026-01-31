//
//  ContentView.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/01/29.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var shoppingLists: [ShoppingList]
    
    @State private var showingAddSheet = false
    @State private var listToEdit: ShoppingList?

    var body: some View {
        NavigationSplitView {
            Group {
                if shoppingLists.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        
                        Text("No Shopping Lists")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        Button(action: { showingAddSheet = true }) {
                            Label("Create List", systemImage: "plus")
                                .font(.headline)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    // List of shopping lists
                    List {
                        ForEach(shoppingLists) { list in
                            NavigationLink {
                                ShoppingListDetailView(shoppingList: list)
                            } label: {
                                ShoppingListRow(shoppingList: list)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteList(list)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    listToEdit = list
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Shopping Lists")
                        .font(.headline)
                }
                
                if !shoppingLists.isEmpty { // Only show add btn in toolbar if there are lists
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddSheet = true }) {
                            Label("Add List", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                ShoppingListFormView()
            }
            .sheet(item: $listToEdit) { list in
                ShoppingListFormView(shoppingList: list)
            }
        } detail: {
            Text("Select a shopping list")
        }
    }

    private func deleteList(_ list: ShoppingList) {
        withAnimation {
            modelContext.delete(list)
        }
    }
}

struct ShoppingListRow: View {
    let shoppingList: ShoppingList
    
    private var itemCount: Int {
        shoppingList.items.count
    }
    
    private var checkedCount: Int {
        shoppingList.items.filter { $0.isChecked }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(shoppingList.name)
                .font(.headline)
            
            HStack {
                if itemCount > 0 {
                    Label("\(checkedCount)/\(itemCount) items", systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No items")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(shoppingList.createdAt, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ShoppingList.self, inMemory: true)
}
