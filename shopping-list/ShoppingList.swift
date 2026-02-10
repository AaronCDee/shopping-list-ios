//
//  ShoppingList.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/01/29.
//

import Foundation
import SwiftData

@Model
final class ShoppingList {
    var name: String
    var createdAt: Date
    var firestoreId: String?
    var lastSyncedAt: Date?
    var ownerId: String?
    
    @Relationship(deleteRule: .cascade, inverse: \ShoppingItem.list)
    var items: [ShoppingItem] = []
    
    // Initializes the item with it's data, including default values
    init(name: String, createdAt: Date = Date()) {
        self.name      = name
        self.createdAt = createdAt
    }
    
    func toFirestoreData() -> [String: Any] {
        [
            "name":       name,
            "createdAt": createdAt,
            "ownerId": ownerId ?? "",
            "items": items.map { $0.toFirestoreData() }
        ]
    }
}
