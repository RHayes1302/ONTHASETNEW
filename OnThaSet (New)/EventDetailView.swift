//
//  EventDetailView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//
import SwiftUI
import SwiftData

struct EventDetailView: View {
    var event: Event
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.title)
                .font(.largeTitle)
                .bold()
            
            Text(event.date, style: .date)
                .foregroundColor(.secondary)
            
            Text(event.locationName)
                .foregroundColor(.gray)
            
            Divider()
            
            Text(event.details)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .toolbar {
            Button("Edit") { isEditing = true }
        }
        .sheet(isPresented: $isEditing) {
            AddEditEventView(eventToEdit: event) { _ in
                isEditing = false
            }
        }
    }
}
