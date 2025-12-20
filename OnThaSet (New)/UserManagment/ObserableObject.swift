//
//  ObserableObject.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/11/25.
//

import Foundation

class AuthService: ObservableObject {
    @Published var currentUser: AppUser? = nil
    
    // ADD THIS LINE: This tells the View if someone is logged in
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    func login(password: String) -> Bool {
        if password == "SetMember77" {
            currentUser = AppUser(id: UUID().uuidString, username: "Member", role: UserRole.member)
            return true
        } else if password == "AdminOnTheSet2025" {
            currentUser = AppUser(id: "admin_1", username: "Admin", role: UserRole.admin)
            return true
        }
        return false
    }
    
    func logout() {
        currentUser = nil
    }
}
