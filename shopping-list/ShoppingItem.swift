//
//  ShoppingItem.swift
//  shopping-list
//

import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var name: String
    var addedAt: Date
    var isChecked: Bool
    var checkedAt: Date?
    
    var list: ShoppingList?
    
    init(name: String, addedAt: Date = Date(), isChecked: Bool = false, checkedAt: Date? = nil) {
        self.name = name
        self.addedAt = addedAt
        self.isChecked = isChecked
        self.checkedAt = checkedAt
    }
}
