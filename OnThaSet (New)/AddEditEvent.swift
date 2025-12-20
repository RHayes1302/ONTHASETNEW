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
    
    // Payment States
    @State private var price: String = "3.00"
    @State private var venmoUser: String = ""
    @State private var cashAppUser: String = ""
    
    // Alert State
    @State private var showPaymentAlert = false
    
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
                        flyerSection
                        formFields
                        planSelectionSection
                        paymentFields
                    }
                    .padding(.bottom, 20)
                }
                
                // --- POST BUTTON ---
                VStack(spacing: 12) {
                    Button(action: { showPaymentAlert = true }) {
                        Text("POST EVENT (\(price == "3.00" ? "$3.00" : "$10.00"))")
                            .font(.headline.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isReadyToSubmit ? Color.yellow : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!isReadyToSubmit)
                    
                    Button("Cancel") { dismiss() }.foregroundColor(.red)
                }
            }
            .padding()
        }
        // --- PAYMENT DISCLAIMER ALERT ---
        .alert("Payment Required", isPresented: $showPaymentAlert) {
            Button("I HAVE PAID") { saveData() }
            Button("CANCEL", role: .cancel) { }
        } message: {
            Text("By clicking 'I HAVE PAID', you confirm that you have sent $\(price) to the administrator. Posts without matching payments will be removed.")
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
    
    private var planSelectionSection: some View {
        fieldContainer(label: "SELECT POSTING PLAN") {
            HStack(spacing: 12) {
                Button(action: { price = "3.00" }) {
                    VStack(spacing: 4) {
                        Text("SINGLE POST").font(.caption2.bold())
                        Text("$3.00").font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(price == "3.00" ? Color.yellow : Color.white.opacity(0.1))
                    .foregroundColor(price == "3.00" ? .black : .white)
                    .cornerRadius(10)
                }
                
                Button(action: { price = "10.00" }) {
                    VStack(spacing: 4) {
                        Text("MONTHLY").font(.caption2.bold())
                        Text("$10.00").font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(price == "10.00" ? Color.yellow : Color.white.opacity(0.1))
                    .foregroundColor(price == "10.00" ? .black : .white)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private var paymentFields: some View {
        VStack(spacing: 24) {
            // VENMO DIRECT BUTTON
            VStack(alignment: .leading, spacing: 10) {
                fieldContainer(label: "VENMO USERNAME") {
                    TextField("@username", text: $venmoUser)
                        .modifier(FormTextFieldStyle())
                        .autocorrectionDisabled()
                }
                
                Button(action: {
                    let cleanVenmo = venmoUser.replacingOccurrences(of: "@", with: "")
                    if let url = URL(string: "https://venmo.com/\(cleanVenmo)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.up.right.square.fill")
                        Text("PAY WITH VENMO")
                    }
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(venmoUser.isEmpty ? Color.gray : Color(red: 0, green: 0.55, blue: 0.88))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(venmoUser.isEmpty)
            }
            
            // CASH APP DIRECT BUTTON
            VStack(alignment: .leading, spacing: 10) {
                fieldContainer(label: "CASH APP TAG") {
                    TextField("$cashtag", text: $cashAppUser)
                        .modifier(FormTextFieldStyle())
                        .autocorrectionDisabled()
                }
                
                Button(action: {
                    let cleanCash = cashAppUser.replacingOccurrences(of: "$", with: "")
                    if let url = URL(string: "https://cash.app/\(cleanCash)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("PAY WITH CASH APP")
                    }
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(cashAppUser.isEmpty ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(cashAppUser.isEmpty)
            }

            fieldContainer(label: "SECURITY PIN") {
                SecureField("Required to delete later", text: $securityCode).modifier(FormTextFieldStyle())
            }
        }
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
                        .overlay(Label("ADD FLYER", systemImage: "photo.badge.plus").foregroundColor(.yellow))
                }
            }
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 18) {
            fieldContainer(label: "EVENT TITLE") { TextField("Title", text: $title).modifier(FormTextFieldStyle()) }
            fieldContainer(label: "LOCATION") { TextField("Address", text: $locationName).modifier(FormTextFieldStyle()) }
        }
    }
    
    private func fieldContainer<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.caption2.bold()).foregroundColor(.yellow).padding(.leading, 5)
            content()
        }
    }
    
    private var isReadyToSubmit: Bool { !title.isEmpty && !securityCode.isEmpty }
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
            price = eventToEdit.price.isEmpty ? "3.00" : eventToEdit.price
            venmoUser = eventToEdit.venmoUser
            cashAppUser = eventToEdit.cashAppUser
        }
    }

    private func saveData() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { placemarks, _ in
            let coordinate = placemarks?.first?.location?.coordinate
            let finalEvent = Event(
                title: title, date: date, category: category, locationName: locationName, details: details, securityCode: securityCode,
                latitude: coordinate?.latitude ?? 0.0, longitude: coordinate?.longitude ?? 0.0,
                price: price, venmoUser: venmoUser, cashAppUser: cashAppUser
            )
            finalEvent.imageData = selectedImageData
            DispatchQueue.main.async { onSave(finalEvent); dismiss() }
        }
    }
}

struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.padding().background(Color.white.opacity(0.1)).cornerRadius(8).foregroundColor(.white)
    }
}
