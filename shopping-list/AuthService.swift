//
//  AuthService.swift
//  shopping-list
//
//  Created by Aaron Delate on 2026/02/10.
//

import FirebaseAuth

@Observable
final class AuthService {
    var userId: String?
    var isSignedIn: Bool { userId != nil }
    
    init() {
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userId = user?.uid
        }
    }
    
    // Sign in anonymously, can upgrade later
    func signInAnonymously() async throws {
        let result = try await Auth.auth().signInAnonymously()
        userId = result.user.uid
    }
}
