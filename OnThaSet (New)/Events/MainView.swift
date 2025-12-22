//
//  MainView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/21/25.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // Branding / Logo
                    Image(systemName: "music.mic")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                        .padding(.bottom, 20)
                    
                    Text("THA SET LIST")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("Discover and post local events")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 40)

                    // BUTTON 1: ACCESS THE LIST
                    NavigationLink(destination: EventHomeView(initialMode: .list)) {
                        MenuButton(title: "VIEW EVENT LIST", icon: "list.bullet", color: .yellow)
                    }

                    // BUTTON 2: ACCESS THE CALENDAR
                    NavigationLink(destination: EventHomeView(initialMode: .calendar)) {
                        MenuButton(title: "VIEW CALENDAR", icon: "calendar", color: .white)
                    }
                    
                    Spacer()
                }
                .padding(30)
            }
        }
    }
}

// Reusable Button Component for the Menu
struct MenuButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(color)
        .foregroundColor(color == .yellow ? .black : .black)
        .cornerRadius(15)
    }
}
