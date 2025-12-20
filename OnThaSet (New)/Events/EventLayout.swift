//
//  EventLayout.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import Foundation
import SwiftData
import UIKit // Required for UIImage

@Model
final class Event {
    var title: String
    var date: Date
    var category: EventCategory
    var locationName: String
    var details: String
    var securityCode: String
    
    // 1. This is the property that actually saves to the database
    @Attribute(.externalStorage) var imageData: Data?
    
    var price: String
    var venmoUser: String
    var cashAppUser: String
    var latitude: Double
    var longitude: Double
    var isFavorite: Bool

    // 2. ADD THIS: The "shortcut" property your View is looking for
    @Transient
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }

    init(
        title: String = "",
        date: Date = Date(),
        category: EventCategory = .community,
        locationName: String = "",
        details: String = "",
        securityCode: String = "",
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        price: String = "",
        venmoUser: String = "",
        cashAppUser: String = "",
        isFavorite: Bool = false
    ) {
        self.title = title
        self.date = date
        self.category = category
        self.locationName = locationName
        self.details = details
        self.securityCode = securityCode
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.venmoUser = venmoUser
        self.cashAppUser = cashAppUser
        self.isFavorite = isFavorite
    }
}
