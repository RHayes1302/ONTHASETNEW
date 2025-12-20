//
//  EventList.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import SwiftUI
import SwiftData

struct EventManagerView: View {
    @Query(sort: \Event.date) private var events: [Event]
    @Environment(\.modelContext) private var modelContext
    @State private var showAdd = false
    
    // We create a "blank" event to pass to the sheet
    @State private var newEvent: Event?

    var body: some View {
        List {
            ForEach(events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventRow(event: event)
                }
            }
            .onDelete(perform: deleteEvents)
        }
        .navigationTitle("Manage Events")
        .toolbar {
            Button(action: {
                newEvent = Event(title: "", date: Date(), category: .community)
                showAdd = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(item: $newEvent) { event in
            AddEditEventView(eventToEdit: event) { savedEvent in
                modelContext.insert(savedEvent)
                try? modelContext.save()
            }
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(events[index])
        }
    }
}
