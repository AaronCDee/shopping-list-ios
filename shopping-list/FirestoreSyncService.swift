//
//  FirestoreSyncService.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/02/10.
//

import FirebaseFirestore
import SwiftData

@Observable
final class FirestoreSyncService {
    private let db = Firestore.firestore()
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    // returns the collection for shopping lists
    private func userListsCollection() -> CollectionReference? {
        guard let uid = authService.userId else { return nil }
        return db.collection("users").document(uid).collection("shoppingLists")
    }
    
    // syncs shopping list changes
    func sync(_ list: ShoppingList) async throws {
        guard let collection = userListsCollection() else {
            throw SyncError.notAuthenticated
        }
        
        let data = list.toFirestoreData()
        
        if let existingId = list.firestoreId {
            // Update existing document
            try await collection.document(existingId).setData(data, merge: true)
        } else {
            // Create new document
            let docRef = try await collection.addDocument(data: data)
            list.firestoreId = docRef.documentID
        }
        
        list.lastSyncedAt = Date()
    }
    
    // deletes a shopping list
    func delete(_ list: ShoppingList) async throws {
        guard let collection = userListsCollection(),
              let firestoreId = list.firestoreId else { return }
        try await collection.document(firestoreId).delete()
    }
    
    // fetches all shopping lists for the given user
    func fetchAll() async throws -> [[String: Any]] {
        guard let collection = userListsCollection() else {
            throw SyncError.notAuthenticated
        }
        let snapshot = try await collection.getDocuments()
        return snapshot.documents.map { doc in
            var data = doc.data()
            data["firestoreId"] = doc.documentID
            return data
        }
    }
    
    
    enum SyncError: LocalizedError {
        case notAuthenticated
        var errorDescription: String? {
            switch self {
            case .notAuthenticated: "User is not signed in."
            }
        }
    }
}

