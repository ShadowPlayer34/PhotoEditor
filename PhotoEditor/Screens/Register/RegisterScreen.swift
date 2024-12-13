//
//  RegisterScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI
import Combine

struct RegisterScreen {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var cancellables = Set<AnyCancellable>()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var mainRouter: MainViewRouter

    @ObservedObject private var registerViewModel: RegisterViewModel = RegisterViewModel()

    private func configurePublishers() {
        registerViewModel.isRegisteredPublisher
            .sink { isRegistered in
                mainRouter.isUserLoggedInPublisher.send(isRegistered)
            }
            .store(in: &cancellables)

        registerViewModel.errorPublisher
            .sink { error in
                guard let error = error else { return }
                errorMessage = error
                isShowAlert = true
            }
            .store(in: &cancellables)
    }
}

extension RegisterScreen: View {
    var body: some View {
        VStack {
            textFields
            CapsuleButton(text: "Sign Up") {
                Task {
                    isLoading = true
                    await registerViewModel.register(
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword
                    )
                    isLoading = false
                }
            }
            .padding(.vertical)
            Spacer()
            signIn
        }
        .withLoaderOverView(isLoading: isLoading)
        .padding()
        .navigationTitle("Sign Up")
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
        .background(
            Rectangle()
                .opacity(0.01)
                .onTapGesture {
                    hideKeyboard()
                }
        )
        .onAppear {
            configurePublishers()
        }
    }

    private var textFields: some View {
        VStack(spacing: 20) {
            CapsuleTextField(text: $email, prompt: "Email")
            CapsuleTextField(text: $password, prompt: "Password", isSecure: true)
            CapsuleTextField(text: $confirmPassword, prompt: "Confirm Password", isSecure: true)
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
