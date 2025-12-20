//
//  NearbyEvents.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import SwiftUI
import SwiftData

struct NearbyEventsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var locationService = LocationManager()
    @Query(sort: \Event.date) var allEvents: [Event]

    var nearbyEvents: [Event] {
        // Only filters if location is available; otherwise shows all
        allEvents.filter { locationService.isNearby(event: $0, radiusInMiles: 50) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if nearbyEvents.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                        Text("No sets within 50 miles")
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(nearbyEvents) { event in
                            EventRow(event: event)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Nearby")
            .onAppear {
                // 4. Force a location refresh when this screen opens
                locationService.requestLocation()
            }
        }
    }
}
