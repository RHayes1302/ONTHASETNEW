//
//  ExtensionView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/19/25.
//

import SwiftUI

extension View {
    func styleEnter() -> some View {
        self.font(.system(size: 14, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(10)
    }
}
