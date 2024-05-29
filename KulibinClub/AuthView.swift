//
//  AuthView.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import Firebase
import FirebaseAuth
import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginMode: Bool = true
    @State private var errorMessage: String = ""
    @Binding var isLoggedIn: Bool

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .center, spacing: 30, content: {
                    Image(.logo2)
                        .resizable().scaledToFit()
                        .frame(width: 200)
                    Image(.infoShar).resizable().scaledToFit().frame(box: 60)
                })

                VStack(alignment: .center) {
                    Image(.about).resizable().aspectRatio(contentMode: .fit).frame(width: .screenWidth)

                        .overlay(alignment: .bottom) {
                            Text(NSLocalizedString("welcome_message", comment: "")).font(.title2).fontWeight(.bold).shadow(.sticker)
                        }.clipped()
                }
                .contentShape(Rectangle()).clipped()

                Text(NSLocalizedString("sign_in_to_continue", comment: ""))

                Picker(selection: $isLoginMode, label: Text("Picker")) {
                    Text(NSLocalizedString("sign_in", comment: "")).tag(true)
                    Text(NSLocalizedString("sign_up", comment: "")).tag(false)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 16)

                TextField(NSLocalizedString("email_placeholder", comment: ""), text: $email)
                    .autocapitalization(.none).textContentType(.emailAddress)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                SecureField(NSLocalizedString("password_placeholder", comment: ""), text: $password)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    handleAuth()
                }) {
                    HStack {
                        Spacer()
                        Text(isLoginMode ? NSLocalizedString("sign_in", comment: "") : NSLocalizedString("sign_up", comment: ""))
                            .font(.title3.bold().monospaced())
                            .padding(12, 16)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        Spacer()
                    }

                    .vibrantForeground(thick: true)
                    .cornerRadius(8)

                }.buttonStyle(.borderedProminent).padding().shadow(.sticker)
            }
        }
        .background {
            LinearGradient(colors: [Color.clear, Color(.about)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        }.frame(width: .screenWidth)
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
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = NSLocalizedString("login_error", comment: "") + error.localizedDescription
                return
            }
            isLoggedIn = true
        }
    }

    private func createUser() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
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
