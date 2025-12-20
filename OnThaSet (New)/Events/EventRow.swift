//
//  EventRow.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import SwiftUI
import SwiftData

struct EventRow: View {
    // 1. Use 'var' instead of '@Binding' for SwiftData models
    var event: Event

    var body: some View {
        HStack(spacing: 12) {
            // 2. This uses the 'image' computed property we added to Event.swift
            if let uiImage = event.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()

            // 3. Use the manual binding for the favorite toggle
            FavoriteToggle(isFavorite: Binding(
                get: { event.isFavorite },
                set: { event.isFavorite = $0 }
            ))
        }
        .padding(.vertical, 4)
    }
}
