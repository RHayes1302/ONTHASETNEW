//
//  AddEditEvent.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//


import SwiftUI
import SwiftData
import PhotosUI

struct AddEditEventView: View {
    @Environment(\.dismiss) private var dismiss
    
    var eventToEdit: Event
    var onSave: (Event) -> Void
    
    // Form States
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var locationName: String = ""
    @State private var category: EventCategory = .community
    @State private var details: String = ""
    @State private var securityCode: String = ""
    
    // Media States
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("EVENT DETAILS")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 25) {
                        flyerSection // The photo icon is the button
                        formFields   // Contains Details and Security
                    }
                    .padding(.bottom, 20)
                }
                
                actionButtons
            }
            .padding()
        }
        .onAppear { loadInitialData() }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
}

// MARK: - UI Sub-Expressions
extension AddEditEventView {
    
    private var flyerSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack {
                if let data = selectedImageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .clipped()
                        .overlay(
                            Text("CHANGE PHOTO")
                                .font(.caption2.bold())
                                .foregroundColor(.black)
                                .padding(6)
                                .background(Color.yellow)
                                .cornerRadius(5)
                                .padding(10),
                            alignment: .bottomTrailing
                        )
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 160)
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 40))
                                    .foregroundColor(.yellow)
                                Text("TAP TO ADD FLYER")
                                    .font(.caption.bold())
                                    .foregroundColor(.yellow)
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.yellow.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private var formFields: some View {
        VStack(spacing: 18) {
            fieldContainer(label: "EVENT TITLE") {
                TextField("What's the set called?", text: $title)
                    .modifier(FormTextFieldStyle())
            }
            
            fieldContainer(label: "DATE & TIME") {
                DatePicker("", selection: $date)
                    .colorScheme(.dark)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            }
            
            fieldContainer(label: "LOCATION") {
                TextField("Venue or Address", text: $locationName)
                    .modifier(FormTextFieldStyle())
            }
            
            fieldContainer(label: "CATEGORY") {
                HStack {
                    Text("Category").foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $category) {
                        ForEach(EventCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            }
            
            fieldContainer(label: "DETAILS / CAPTION") {
                TextEditor(text: $details)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            
            fieldContainer(label: "SECURITY CODE (REQUIRED TO DELETE)") {
                SecureField("Enter a private pin", text: $securityCode)
                    .modifier(FormTextFieldStyle())
            }
        }
    }
    
    private func fieldContainer<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.caption2.bold())
                .foregroundColor(.yellow)
                .padding(.leading, 5)
            content()
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: saveData) {
                Text("POST EVENT")
                    .font(.headline.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isReadyToSubmit ? Color.yellow : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isReadyToSubmit)
            
            Button("Cancel") { dismiss() }
                .font(.subheadline)
                .foregroundColor(.red)
        }
    }
    
    private var isReadyToSubmit: Bool {
        !title.isEmpty && !securityCode.isEmpty
    }
}

// MARK: - Logic
extension AddEditEventView {
    private func loadInitialData() {
        if !eventToEdit.title.isEmpty {
            title = eventToEdit.title
            date = eventToEdit.date
            locationName = eventToEdit.locationName
            category = eventToEdit.category
            details = eventToEdit.details
            securityCode = eventToEdit.securityCode
            selectedImageData = eventToEdit.imageData
        }
    }

    private func saveData() {
        // We create a fresh new event to ensure SwiftData recognizes it as a new entry
        let finalEvent = Event(
            title: title,
            date: date,
            category: category,
            locationName: locationName,
            details: details,
            securityCode: securityCode
        )
        finalEvent.imageData = selectedImageData
        
        onSave(finalEvent) // Passes to DefaultPageView for modelContext.insert()
        dismiss()
    }
}

// Global UI Modifier
struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}
