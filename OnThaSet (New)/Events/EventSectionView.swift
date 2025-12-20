//
//  EventSectionView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import SwiftUI
import SwiftData

struct EventSectionView: View {
    @EnvironmentObject var authService: AuthService
    
    // This fetches all events from the database automatically
    @Query(sort: \Event.date) var events: [Event]
    
    var categoryFilter: EventCategory?

    // This filters the results based on the category passed into this view
    var filteredEvents: [Event] {
        guard let filter = categoryFilter else { return events }
        return events.filter { $0.category == filter }
    }

    var body: some View {
        List {
            if filteredEvents.isEmpty {
                Text("No events in this category.")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ForEach(filteredEvents) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRow(event: event)
                    }
                }
            }
        }
        .navigationTitle(categoryFilter?.displayName ?? "Events")
    }
}
