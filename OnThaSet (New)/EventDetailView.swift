//
//  EventDetailView.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//
import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var event: Event
    
    // Security State
    @State private var showingDeleteAlert = false
    @State private var inputCode = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. RESTORED PHOTO SECTION
                    if let uiImage = event.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // 2. RESTORED TITLE
                        Text(event.title)
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.yellow)
                        
                        // 3. RESTORED DATE & TIME
                        HStack {
                            Image(systemName: "calendar")
                            Text(event.date, style: .date)
                            Text("at")
                            Text(event.date, style: .time)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        // 4. RESTORED LOCATION NAME
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                            Text(event.locationName.isEmpty ? "Location not set" : event.locationName)
                        }
                        .foregroundColor(.gray)
                        
                        Divider().background(Color.yellow.opacity(0.5))
                        
                        // 5. RESTORED DETAILS
                        Text("DETAILS")
                            .font(.caption.bold())
                            .foregroundColor(.yellow)
                        
                        Text(event.details)
                            .foregroundColor(.white)
                            .lineSpacing(5)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                    
                    // 6. DELETE BUTTON WITH SECURITY
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Remove This Post", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        // SECURITY ALERT LOGIC
        .alert("Verify Security Code", isPresented: $showingDeleteAlert) {
            SecureField("Enter Code", text: $inputCode)
            Button("Cancel", role: .cancel) { inputCode = "" }
            Button("Verify & Delete", role: .destructive) {
                if inputCode == event.securityCode || inputCode == "Pokemon122!!" {
                    modelContext.delete(event)
                    try? modelContext.save()
                    dismiss()
                }
                inputCode = ""
            }
        } message: {
            Text("Please enter the author's code or the Master Password to delete this event.")
        }
    }
}
