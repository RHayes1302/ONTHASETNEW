//
//  EntryPoint.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/11/25.
//

import SwiftUI
import SwiftData

@main
struct OnTheSetApp: App {
    @StateObject private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            // Remove '(events: $events)' here
            ContentView()
                .environmentObject(authService)
        }
        // This tells the app to manage the 'Event' database
        .modelContainer(for: Event.self)
    }
}
