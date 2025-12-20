//
//  LocationManager.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // 1. Request permission when the manager starts
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        // 2. Explicitly ask for a location update
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        manager.stopUpdatingLocation() // Stop to save battery
    }
    
    // 3. Helper function to calculate distance
    func isNearby(event: Event, radiusInMiles: Double) -> Bool {
        guard let userLoc = userLocation else { return true } // Show all if location is unknown
        let eventLoc = CLLocation(latitude: event.latitude, longitude: event.longitude)
        let distanceInMeters = userLoc.distance(from: eventLoc)
        let distanceInMiles = distanceInMeters / 1609.34
        return distanceInMiles <= radiusInMiles
    }
}
