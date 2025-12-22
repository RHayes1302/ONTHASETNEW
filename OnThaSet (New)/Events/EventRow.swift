//
//  EventRow.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import SwiftUI  // <--- This is the missing piece
import SwiftData // You also need this to access your Events


struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 15) {
            // Mini Flyer Thumbnail
            if let data = event.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(Image(systemName: "music.note").foregroundColor(.yellow))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(event.title.uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                
                Label(event.locationName, systemImage: "mappin")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
