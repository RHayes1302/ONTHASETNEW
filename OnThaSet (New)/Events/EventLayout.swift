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
class Event: Identifiable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var category: EventCategory
    var locationName: String = ""
    var details: String = ""
    var isFavorite: Bool = false
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var securityCode: String = "" // NEW: Stores the pin
    @Attribute(.externalStorage) var imageData: Data?

    @Transient
    var image: UIImage? {
        get {
            guard let data = imageData else { return nil }
            return UIImage(data: data)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }

    init(title: String, date: Date, category: EventCategory, locationName: String = "", details: String = "", securityCode: String = "") {
        self.id = UUID()
        self.title = title
        self.date = date
        self.category = category
        self.locationName = locationName
        self.details = details
        self.securityCode = securityCode
    }
}
