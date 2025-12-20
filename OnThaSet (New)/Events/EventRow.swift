//
//  EventRow.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/7/25.
//

import SwiftUI

struct EventRow: View {
    var event: Event

    var body: some View {
        HStack(spacing: 12) {
            if let uiImage = event.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
            }

            VStack(alignment: .leading) {
                Text(event.title).font(.headline)
                Text(event.date, style: .date).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            FavoriteToggle(isFavorite: Binding(
                get: { event.isFavorite },
                set: { event.isFavorite = $0 }
            ))
        }
    }
}
