//
//  AddEditEvent.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/4/25.
//


import SwiftUI
import SwiftData
import PhotosUI
import CoreLocation

struct AddEditEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var eventToEdit: Event
    var onSave: (Event) -> Void
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var locationName: String = ""
    @State private var category: EventCategory = .community
    @State private var details: String = ""
    @State private var securityCode: String = ""
    @State private var price: String = "3.00"
    @State private var showPaymentAlert = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // BRANDED HEADER
                headerSection
                
                ScrollView {
                    VStack(spacing: 25) {
                        flyerSection
                        formFields
                        planSelectionSection
                        paymentButtonsSection
                    }
                    .padding()
                }
                
                submitButtonSection
            }
        }
        .navigationBarHidden(true)
        .alert("Confirm Payment", isPresented: $showPaymentAlert) {
            Button("I HAVE PAID") { saveData() }
            Button("CANCEL", role: .cancel) { }
        } message: {
            Text("Confirm payment has been sent. Your post will be verified by the admin.")
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

    // MARK: - Sub-Views

    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.yellow)
                    .font(.title3.bold())
            }
            Spacer()
            ZStack {
                Image(systemName: "shield.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.yellow)
                VStack(spacing: -1) {
                    Text("ON").font(.system(size: 7, weight: .black))
                    Text("THA").font(.system(size: 6, weight: .black))
                    Text("SET").font(.system(size: 9, weight: .black))
                }
                .foregroundColor(.black)
                .offset(y: -2)
            }
            Spacer()
            Image(systemName: "xmark").opacity(0)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }

    private var flyerSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack {
                if let data = selectedImageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 150)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo.badge.plus").font(.title)
                                Text("ADD EVENT FLYER").font(.caption.bold())
                            }
                            .foregroundColor(.yellow)
                        )
                }
            }
        }
    }

    private var formFields: some View {
        VStack(spacing: 18) {
            fieldContainer(label: "EVENT TITLE") {
                TextField("Set Name", text: $title).modifier(FormTextFieldStyle())
            }
            fieldContainer(label: "LOCATION") {
                TextField("Venue / Address", text: $locationName).modifier(FormTextFieldStyle())
            }
            fieldContainer(label: "DETAILS") {
                TextField("Description", text: $details, axis: .vertical)
                    .lineLimit(3...5)
                    .modifier(FormTextFieldStyle())
            }
        }
    }

    private var planSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SELECT PLAN").font(.caption2.bold()).foregroundColor(.yellow)
            HStack(spacing: 12) {
                planBtn(label: "SINGLE POST", val: "3.00")
                planBtn(label: "UNLIMITED MONTH", val: "10.00")
            }
        }
    }

    private func planBtn(label: String, val: String) -> some View {
        Button(action: { price = val }) {
            VStack {
                Text(label).font(.system(size: 8, weight: .black))
                Text("$\(val)").font(.headline.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(price == val ? Color.yellow : Color.white.opacity(0.1))
            .foregroundColor(price == val ? .black : .white)
            .cornerRadius(10)
        }
    }

    private var paymentButtonsSection: some View {
        VStack(spacing: 15) {
            Text("PAYMENT METHOD").font(.caption2.bold()).foregroundColor(.yellow).frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 10) {
                // FIXED APPLE PAY BUTTON
                Button(action: { showPaymentAlert = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 16))
                        Text("Pay")
                            .font(.system(size: 19, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                
                payBtn(label: "Venmo", color: Color(red: 0, green: 0.5, blue: 1)) { openURL("https://venmo.com/") }
                payBtn(label: "Cash App", color: .green) { openURL("https://cash.app/") }
            }
            fieldContainer(label: "SECURITY PIN (REQUIRED)") {
                SecureField("4-digit pin", text: $securityCode)
                    .modifier(FormTextFieldStyle())
                    .keyboardType(.numberPad)
            }
        }
    }

    private func payBtn(label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .black))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    private var submitButtonSection: some View {
        Button(action: { showPaymentAlert = true }) {
            Text("CONFIRM & POST")
                .font(.headline.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(!title.isEmpty && !securityCode.isEmpty ? Color.yellow : Color.gray)
                .cornerRadius(12)
        }
        .disabled(title.isEmpty || securityCode.isEmpty)
        .padding()
    }

    private func fieldContainer<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.caption2.bold()).foregroundColor(.yellow).padding(.leading, 5)
            content()
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) { UIApplication.shared.open(url) }
    }

    // MARK: - Logic & Helpers
    
    func loadInitialData() {
        if !eventToEdit.title.isEmpty {
            title = eventToEdit.title
            date = eventToEdit.date
            locationName = eventToEdit.locationName
            category = eventToEdit.category
            details = eventToEdit.details
            securityCode = eventToEdit.securityCode
            selectedImageData = eventToEdit.imageData
            price = eventToEdit.price
        }
    }

    func saveData() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { placemarks, _ in
            let coordinate = placemarks?.first?.location?.coordinate
            let finalEvent = Event(
                title: title, date: date, category: category,
                locationName: locationName, details: details,
                securityCode: securityCode, price: price,
                latitude: coordinate?.latitude ?? 0.0,
                longitude: coordinate?.longitude ?? 0.0
            )
            finalEvent.imageData = selectedImageData
            onSave(finalEvent)
            dismiss()
        }
    }
}

// Global View Modifier
struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.padding().background(Color.white.opacity(0.1)).cornerRadius(8).foregroundColor(.white)
    }
}
