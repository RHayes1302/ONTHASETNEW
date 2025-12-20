//
//  DefaultPageView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import SwiftUI
import SwiftData

struct DefaultPageView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Event.date) private var allEvents: [Event]
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        
                        // 1. HEADER
                        Text("ON-THE-SET")
                            .font(.system(size: 32, weight: .black))
                            .padding(.horizontal, 25)
                            .padding(.vertical, 5)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .padding(.top, 40)

                        // 2. FEATURED CARDS
                        if !allEvents.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("HOTTEST SETS")
                                    .font(.system(size: 22, weight: .black))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(allEvents) { event in
                                            NavigationLink(destination: EventDetailView(event: event)) {
                                                MeanEventCard(event: event)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            Image("ONTHASET") // Ensure this image is in your Assets
                                .resizable()
                                .scaledToFill()
                                .frame(width: 280, height: 280)
                                .clipped()
                                .border(Color.white, width: 1)
                        }

                        Text("What's On The Set Nearby")
                            .font(.title2.bold())
                            .foregroundColor(.yellow)

                        // 3. ACTION BUTTONS
                        VStack(spacing: 12) {
                            // Points to your Nearby logic
                            NavigationLink(destination: NearbyEventsView()) {
                                makeMenuButton(text: "EVENTS NEARBY")
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                locationManager.requestLocation()
                            })

                            NavigationLink(destination: AddEditEventView(
                                eventToEdit: Event(title: "", date: Date(), category: .community),
                                onSave: { newEvent in
                                    modelContext.insert(newEvent)
                                    try? modelContext.save()
                                }
                            )) {
                                makeMenuButton(text: "POST EVENT")
                            }

                            // FIXED: Points to AboutView instead of blank Text
                            NavigationLink(destination: AboutView()) {
                                makeMenuButton(text: "ABOUT")
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }

    func makeMenuButton(text: String) -> some View {
        Text(text)
            .font(.headline.bold())
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.yellow)
            .cornerRadius(8)
    }
}
