//
//  ForgotPasswordView.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI

struct ResetPasswordModal: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShowAlert: Bool = false

    @ObservedObject var logInViewModel: LoginViewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your email to reset the password")
                .font(.headline)

            CapsuleTextField(text: $email, prompt: "Email")
                .padding(.top, 20)

            Button(action: {
                Task {
                    isLoading = true
                    do {
                        try await logInViewModel.resetPassword(email: email)
                        dismiss() // Close modal after successful password reset
                    } catch {
                        errorMessage = error.localizedDescription
                        isShowAlert = true
                    }
                    isLoading = false
                }
            }) {
                Text("Reset Password")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isLoading)

            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
    }
}
