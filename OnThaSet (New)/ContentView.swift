//
//  ContentView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        // Remove the $ prefix here
        if authService.isLoggedIn {
            HomePageView()
        } else {
            DefaultPageView()
        }
    }
}
