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
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationService = LocationManager()
    @Query(sort: \Event.date) var allEvents: [Event]

    var nearbyEvents: [Event] {
        allEvents.filter { locationService.isNearby(event: $0, radiusInMiles: 50) }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. UPDATED BRANDED HEADER (Larger Shield, No Banner)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.yellow)
                            .font(.title2.bold())
                    }
                    
                    Spacer()
                    
                    // Larger Branded Shield
                    ZStack {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 70)) // Increased size significantly
                            .foregroundColor(.yellow)
                        
                        VStack(spacing: -2) {
                            Text("ON")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.black)
                            Text("THA")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.black)
                            Text("SET")
                                .font(.system(size: 15, weight: .black))
                                .foregroundColor(.black)
                        }
                        .offset(y: -3)
                    }
                    
                    Spacer()
                    
                    // Refresh Button
                    Button(action: { locationService.requestLocation() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .padding(.bottom, 20) // Spacing before the list starts

                // 2. CONTENT AREA
                if nearbyEvents.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow.opacity(0.3))
                        Text("No events within 50 miles")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Button(action: { locationService.requestLocation() }) {
                            Text("REFRESH LOCATION")
                                .font(.caption.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.yellow)
                                .cornerRadius(5)
                        }
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(nearbyEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventRow(event: event)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.gray.opacity(0.2))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            locationService.requestLocation()
        }
    }
}
