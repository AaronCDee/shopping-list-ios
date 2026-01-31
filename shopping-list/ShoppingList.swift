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
    
    @Relationship(deleteRule: .cascade, inverse: \ShoppingItem.list)
    var items: [ShoppingItem] = []
    
    init(name: String, createdAt: Date = Date()) {
        self.name      = name
        self.createdAt = createdAt
    }
}
