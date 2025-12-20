//
//  NearbyEvents.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import SwiftUI
import CoreLocation
import SwiftData

struct NearbyEventsView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var locationService = LocationManager()
    
    @Query(sort: \Event.date) var allEvents: [Event]
    var radiusInMiles: Double = 50

    // Filters the events based on the LocationManager logic
    var nearbyEvents: [Event] {
        let filtered: [Event] = allEvents.filter { event in
            locationService.isNearby(event: event, radiusInMiles: radiusInMiles)
        }
        return filtered
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if nearbyEvents.isEmpty {
                    emptyStateView
                } else {
                    eventListView
                }
            }
            .navigationTitle("Nearby Events")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                locationService.requestLocation()
            }
        }
    }
}

// MARK: - Sub-Views
extension NearbyEventsView {
    
    private var eventListView: some View {
        List {
            ForEach(nearbyEvents as [Event], id: \.self) { event in
                eventRowContainer(for: event)
                    .listRowBackground(Color.black.opacity(0.8))
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func eventRowContainer(for event: Event) -> some View {
        HStack {
            NavigationLink(destination: EventDetailView(event: event)) {
                EventRow(event: event)
            }
            
            Spacer()
            
            Button(action: {
                locationService.openMapForEvent(event)
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 18))
                    Text("GO")
                        .font(.caption2.bold())
                }
                .foregroundColor(.yellow)
                .padding(8)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text("No nearby events found.")
                .foregroundColor(.gray)
                .italic()
            
            if locationService.location == nil {
                Text("Searching for location...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
