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
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var locationName: String = ""
    @State private var category: EventCategory = .community
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("EVENT DETAILS")
                    .font(.headline)
                    .foregroundColor(.yellow)
                
                ScrollView {
                    VStack(spacing: 15) {
                        flyerSection // sub-expression 1
                        formFields   // sub-expression 2
                    }
                }
                
                actionButtons        // sub-expression 3
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

// MARK: - Sub-Expressions
extension AddEditEventView {
    
    private var flyerSection: some View {
        VStack {
            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .cornerRadius(10)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 150)
                    .overlay(Image(systemName: "photo.badge.plus").foregroundColor(.yellow))
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Select Flyer").font(.caption).foregroundColor(.yellow)
            }
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 15) {
            TextField("Title", text: $title)
                .modifier(FormTextFieldStyle())
            
            DatePicker("Date", selection: $date)
                .colorScheme(.dark)
                .padding()
            
            TextField("Location", text: $locationName)
                .modifier(FormTextFieldStyle())
            
            categoryPicker
        }
    }
    
    private var categoryPicker: some View {
        HStack {
            Text("Category").foregroundColor(.white)
            Spacer()
            Picker("Category", selection: $category) {
                ForEach(EventCategory.allCases, id: \.self) { cat in
                    Text(cat.displayName).tag(cat)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: saveData) {
                Text("SUBMIT")
                    .font(.headline.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty ? Color.gray : Color.yellow)
                    .cornerRadius(12)
            }
            .disabled(title.isEmpty)
            
            Button("Cancel") { dismiss() }
                .foregroundColor(.red)
        }
    }
}

// MARK: - Logic & Styles
extension AddEditEventView {
    private func loadInitialData() {
        title = eventToEdit.title
        date = eventToEdit.date
        locationName = eventToEdit.locationName
        category = eventToEdit.category
        selectedImageData = eventToEdit.imageData
    }

    private func saveData() {
        eventToEdit.title = title
        eventToEdit.date = date
        eventToEdit.locationName = locationName
        eventToEdit.category = category
        eventToEdit.imageData = selectedImageData
        onSave(eventToEdit)
        dismiss()
    }
}

struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}
