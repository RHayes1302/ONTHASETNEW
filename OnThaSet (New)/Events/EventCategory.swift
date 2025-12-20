//
//  EventCategory.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import Foundation
import SwiftUI

enum EventCategory: String, CaseIterable, Codable, Hashable {
    case annuals = "Annuals"
    case weeklyClubhouse = "Weekly Clubhouse"
    case charity = "Charity"
    case community = "Community" // Add this back
    var displayName: String { rawValue }
}

enum AnnualsSubCategory: String, CaseIterable, Codable, Hashable {
    case outlaws = "Outlaws (1%)"
    case mc99 = "Motorcycle Clubs (99%)"
    case femaleSocial = "Female Social Clubs"
    case none = "None"
    var displayName: String { rawValue }
}

enum EventStatus: String, CaseIterable, Codable, Hashable {
    case partyStillOn = "Party Still On"
    case cancelled = "Cancelled"
    var displayName: String { rawValue }
}
