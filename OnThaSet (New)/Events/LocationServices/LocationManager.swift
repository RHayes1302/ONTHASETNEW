//
//  LocationManager.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    // Logic to calculate distance between user and event
    func isNearby(event: Event, radiusInMiles: Double) -> Bool {
        guard let userLoc = self.location else { return false }
        
        let eventLoc = CLLocation(latitude: event.latitude, longitude: event.longitude)
        let distanceInMeters = userLoc.distance(from: eventLoc)
        let distanceInMiles = distanceInMeters / 1609.34
        
        return distanceInMiles <= radiusInMiles
    }

    // Logic to open Apple Maps
    func openMapForEvent(_ event: Event) {
        let coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.title
        mapItem.openInMaps()
    }
}
