//
//  EventLink.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//
import SwiftUI

struct EventLinkItem: View {
    // 1. Change @Binding to a simple 'var'
    var event: Event 
    
    var body: some View {
        HStack(spacing: 12) {
            // 2. Remove the '$' - use the property directly from the object
            if let image = event.image { 
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipped()
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 55, height: 55)
                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title).font(.headline)
                Text(event.date, style: .date).font(.subheadline).foregroundColor(.gray)
            }
            
            Spacer()
            
            // 3. For the toggle, we create a manual binding to the property
            FavoriteToggle(isFavorite: Binding(
                get: { event.isFavorite },
                set: { event.isFavorite = $0 }
            ))
        }
        .padding(.vertical, 4)
    }
}

