//
//  RegisterScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI

struct RegisterScreen {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) private var dismiss
}

extension RegisterScreen: View {
    var body: some View {
        VStack {
            textFields
            CustomButton(text: "Sign Up") {
                // TODO: Implement
            }
            Spacer()
            signIn
        }
        .padding()
        .navigationTitle("Sign Up")
        .navigationBarBackButtonHidden(true)
    }

    private var textFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $email, prompt: "Email")
            CustomTextField(text: $password, prompt: "Password", isSecure: true)
            CustomTextField(text: $confirmPassword, prompt: "Confirm Password", isSecure: true)
        }
        .padding(.top, 50)
    }

    private var signIn: some View {
        HStack {
            Text("Already have an account?")
            Button("Sign In") {
                dismiss()
            }
        }
    }
}

#Preview {
    RegisterScreen()
}
