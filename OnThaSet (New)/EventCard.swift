//
//  EventCard.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import SwiftUI

struct MeanEventCard: View {
    let event: Event
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 1. Background Image (Flyer)
            if let uiImage = event.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 400)
                    .clipped()
            } else {
                Color.gray
                    .frame(width: 300, height: 400)
                    .overlay(Image(systemName: "photo").foregroundColor(.white.opacity(0.3)))
            }
            
            // 2. Dark Gradient Overlay for Readability
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            // 3. Text Content
            VStack(alignment: .leading, spacing: 8) {
                Text(event.category.displayName.uppercased())
                    .font(.caption2)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                
                Text(event.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(event.locationName)
                }
                .font(.caption)
                .foregroundColor(.yellow)
            }
            .padding()
        }
        .frame(width: 300, height: 400)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}
