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
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    // Updated helper function
    func isNearby(event: Event, radiusInMiles: Double) -> Bool {
        // If we can't find the user, we show the event anyway so the list isn't blank
        guard let userLoc = userLocation else { return true }
        
        // Ensure the event actually has coordinates set
        guard event.latitude != 0.0 && event.longitude != 0.0 else { return true }
        
        let eventLoc = CLLocation(latitude: event.latitude, longitude: event.longitude)
        let distanceInMeters = userLoc.distance(from: eventLoc)
        
        // Convert meters to miles
        let distanceInMiles = distanceInMeters / 1609.34
        return distanceInMiles <= radiusInMiles
    }
}
