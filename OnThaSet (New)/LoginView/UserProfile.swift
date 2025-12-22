//
//  UserProfile.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/21/25.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var appleUserID: String
    var email: String
    var postsThisMonth: Int
    var lastPostDate: Date?
    var isSubscribed: Bool
    
    init(appleUserID: String = "", email: String = "", postsThisMonth: Int = 0, isSubscribed: Bool = false) {
        self.appleUserID = appleUserID
        self.email = email
        self.postsThisMonth = postsThisMonth
        self.isSubscribed = isSubscribed
        self.lastPostDate = Date()
    }
}
