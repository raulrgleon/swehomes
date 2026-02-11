//
//  AuthService.swift
//  Real_State
//
//  Mock authentication service.
//

import Foundation
import Combine

final class AuthService: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userName: String? = nil
    @Published var userEmail: String? = nil
    
    func login(provider: String) {
        isLoggedIn = true
        userName = "Alex Johnson"
        userEmail = "alex@example.com"
    }
    
    func logout() {
        isLoggedIn = false
        userName = nil
        userEmail = nil
    }
}
