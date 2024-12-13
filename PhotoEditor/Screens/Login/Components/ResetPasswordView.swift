//
//  ResetPasswordView.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI
import Combine

/// A  view that allows the user to reset their password by entering their email.
struct ResetPasswordView {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShowAlert: Bool = false
    @State private var isPasswordReseted: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    @ObservedObject var logInViewModel: LoginViewModel = LoginViewModel()

    private func congfigurePublishers() {
        logInViewModel.errorPublisher.send(nil)
        logInViewModel.errorPublisher
            .sink { error in
                guard let error = error else { return }
                errorMessage = error.description
                isShowAlert = true
            }
            .store(in: &cancellables)

        logInViewModel.isPasswordResetPublisher
            .sink { isResseted in
                if isResseted {
                    isPasswordReseted = isResseted
                }
            }
            .store(in: &cancellables)
    }
}

extension ResetPasswordView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your email to reset the password")
                .font(.headline)
            CapsuleTextField(text: $email, prompt: "Email")
                .padding(.top, 20)
            CapsuleButton(text: "Reset Password") {
                Task {
                    isLoading = true
                    await logInViewModel.resetPassword(email: email)
                    isLoading = false
                }
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
        .alert(isPresented: $isPasswordReseted) {
            Alert(title: Text("We have sent you a reset link to your email"), dismissButton: .cancel(Text("OK"), action: {
                dismiss()
                logInViewModel.isPasswordResetPublisher.send(false)
            }))
        }
        .withLoaderOverView(isLoading: isLoading)
        .onAppear {
            congfigurePublishers()
        }
    }
}
