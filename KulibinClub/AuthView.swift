//
//  AuthView.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginMode: Bool = true
    @State private var errorMessage: String = ""
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            
            Image(.appstore)
                .resizable()
                              
                .cornerRadius(8)
                .scaledToFill()

                .padding(.horizontal, 44)
            Text(NSLocalizedString("welcome_message", comment: "")).font(.title3).fontWeight(.bold)
            
            Text("Развивающие занятия для детей и подростков")
            
            Picker(selection: $isLoginMode, label: Text("Picker")) {
                Text(NSLocalizedString("sign_in", comment: "")).tag(true)
                Text(NSLocalizedString("sign_up", comment: "")).tag(false)
            }.pickerStyle(SegmentedPickerStyle())
            
            TextField(NSLocalizedString("email_placeholder", comment: ""), text: $email)
                .autocapitalization(.none).textContentType(.emailAddress)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(8)
            
            SecureField(NSLocalizedString("password_placeholder", comment: ""), text: $password)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(8)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                handleAuth()
            }) {
                Text(isLoginMode ? NSLocalizedString("sign_in", comment: "") : NSLocalizedString("sign_up", comment: ""))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
        }
        .padding()
    }
    
    private func handleAuth() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = NSLocalizedString("fill_all_fields", comment: "")
            return
        }
        
        if isLoginMode {
            loginUser()
        } else {
            createUser()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = NSLocalizedString("login_error", comment: "") + error.localizedDescription
                return
            }
            isLoggedIn = true
        }
    }
    
    private func createUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = NSLocalizedString("register_error", comment: "") + error.localizedDescription
                return
            }
            isLoggedIn = true
        }
    }
}

#Preview {
    AuthView(isLoggedIn: .constant(false))
}
