//
//  EventLayout.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import Foundation
import SwiftData
import UIKit

@Model
class Event {
    var title: String
    var date: Date
    var category: EventCategory
    var locationName: String
    var details: String
    var securityCode: String
    var price: String
    
    // ADD THIS LINE TO FIX THE ERROR
    var isFavorite: Bool = false
    
    @Attribute(.externalStorage) var imageData: Data?
    var latitude: Double
    var longitude: Double
    
    init(
        title: String = "",
        date: Date = Date(),
        category: EventCategory = .community,
        locationName: String = "",
        details: String = "",
        securityCode: String = "",
        price: String = "3.00",
        isFavorite: Bool = false, // Add to initializer
        latitude: Double = 0.0,
        longitude: Double = 0.0
    ) {
        self.title = title
        self.date = date
        self.category = category
        self.locationName = locationName
        self.details = details
        self.securityCode = securityCode
        self.price = price
        self.isFavorite = isFavorite
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Helper for displaying the image
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
}
