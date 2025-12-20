//
//  AboutPage.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//po

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. REFINED SLIM HEADER
                VStack(spacing: 8) {
                    Text("ON-THA-SET")
                        .font(.system(size: 24, weight: .black))
                        .tracking(2) // Adds space between letters for a premium look
                        .foregroundColor(.yellow)
                    
                    // A slim accent line instead of a big block
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 60, height: 3)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // MISSION SECTION
                        VStack(alignment: .leading, spacing: 10) {
                            Text("THE MISSION")
                                .font(.caption.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.yellow) // Small yellow accent
                            
                            Text("On-The-Set is designed to bridge the gap between event organizers and the local community. We believe in real-time discovery of the vibes around you.")
                                .foregroundColor(.white)
                                .font(.body)
                                .lineSpacing(4)
                        }
                        
                        Divider().background(Color.gray.opacity(0.3))
                        
                        // FEATURES SECTION
                        VStack(alignment: .leading, spacing: 15) {
                            Text("HOW TO USE")
                                .font(.caption.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.yellow)
                            
                            VStack(alignment: .leading, spacing: 18) {
                                FeatureRow(icon: "flame.fill", title: "Discover", desc: "Check 'Hottest Sets' for featured events.")
                                FeatureRow(icon: "mappin.and.ellipse", title: "Locate", desc: "Find events within 50 miles of you.")
                                FeatureRow(icon: "plus.square.fill", title: "Share", desc: "Post your own events to the community.")
                            }
                        }
                        
                        Spacer(minLength: 50)
                        
                        // FOOTER
                        VStack(spacing: 4) {
                            Text("Version 1.0.0")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                            Text("© 2024 ON-THE-SET")
                                .font(.system(size: 10))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(30)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Subview for cleaner Feature layout
struct FeatureRow: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .font(.system(size: 20))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
