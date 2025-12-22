//
//  Gate.swift
//  OnThaSet (New)
//
//  Created by Ramone Hayes on 12/21/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // 1. BRANDED HIGHWAY SIGN LOGO
                VStack(spacing: -5) {
                    ZStack {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.yellow)
                        
                        VStack(spacing: -2) {
                            Text("ON")
                                .font(.system(size: 16))
                                .fontWeight(.black)
                                .foregroundColor(.black)
                            Text("THA")
                                .font(.system(size: 12))
                                .fontWeight(.black)
                                .foregroundColor(.black)
                            Text("SET")
                                .font(.system(size: 20))
                                .fontWeight(.black)
                                .foregroundColor(.black)
                        }
                        .offset(y: -4)
                    }
                }
                
                // 2. MESSAGING
                VStack(spacing: 10) {
                    Text("SIGN IN TO POST")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Text("Log in to manage your 4 monthly events and keep the community updated.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                // 3. APPLE SIGN IN
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    handleLogin(result: result)
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .padding(.horizontal, 40)
                
                // 4. BACK BUTTON (Directs back to Default Page)
                Button(action: { dismiss() }) {
                    Text("GO BACK")
                        .font(.caption.bold())
                        .foregroundColor(.yellow)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .border(Color.yellow, width: 1)
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.yellow)
                }
            }
        }
    }
    
    func handleLogin(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                // Create profile with unique Apple ID
                let newProfile = UserProfile(
                    appleUserID: appleIDCredential.user,
                    email: appleIDCredential.email ?? ""
                )
                modelContext.insert(newProfile)
                
                // Return to DefaultPageView
                dismiss()
            }
        case .failure(let error):
            print("Auth failed: \(error.localizedDescription)")
        }
    }
}
