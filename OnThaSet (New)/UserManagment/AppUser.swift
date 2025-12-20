//
//  AppUser.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/11/25.
//

import Foundation

struct AppUser: Identifiable {
    let id: String
    let username: String
    let role: UserRole
}

enum UserRole: String {
    case admin
    case member
    case guest
}
