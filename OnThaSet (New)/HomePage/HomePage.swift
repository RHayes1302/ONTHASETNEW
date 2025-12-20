//
//  HomePage.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//


import SwiftUI
import SwiftData

struct HomePageView: View {
    @EnvironmentObject var authService: AuthService
    @Query(sort: \Event.date) var events: [Event]

    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRow(event: event)
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") { authService.logout() }
                }
            }
        }
    }
}
