//
//  LoginScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import SwiftUI
import Combine

struct LoginScreen {
    @State private var isLoading: Bool = false
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var isShowPassword: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShowResetPassword: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    @ObservedObject private var logInViewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject private var mainRoute: MainViewRouter

    private func configurePublishers() {
        logInViewModel.errorPublisher
            .sink { error in
                guard let error = error else { return }
                errorMessage = error.description
                isShowAlert = true
            }
            .store(in: &cancellables)

        logInViewModel.isLoggedInPublisher
            .sink { isLoggedIn in
                mainRoute.isUserLoggedInPublisher.send(isLoggedIn)
            }
            .store(in: &cancellables)
    }
}

extension LoginScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                inputTextFields
                forgotPasswordButton
                logInButton
                Spacer()
                Text("Or Sign in with")
                socialLoginButton
                signUpButton
            }
            .padding()
            .navigationTitle("Log In")
        }
        .withLoaderOverView(isLoading: isLoading)
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage))
        }
        .sheet(isPresented: $isShowResetPassword, content: {
            ResetPasswordView(logInViewModel: logInViewModel)
        })
        .onAppear {
            configurePublishers()
        }
    }

    @ViewBuilder private var inputTextFields: some View {
        VStack(spacing: 20) {
            CapsuleTextField(text: $mail, prompt: "Mail")

            HStack {
                CapsuleTextField(text: $password, prompt: "Password", isSecure: !isShowPassword)
                Button {
                    isShowPassword.toggle()
                } label: {
                    Text("Show")
                }
            }
        }
        .padding(.top, 50)
    }

    @ViewBuilder private var socialLoginButton: some View {
        Button {
            Task {
                isLoading = true
                await logInViewModel.signInWithGoogle()
                isLoading = false
            }
        } label: {
            Image("Google")
                .resizable()
                .frame(width: 50, height: 50)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
        }
        .padding()
    }

    @ViewBuilder private var signUpButton: some View {
        HStack {
            Text("Don't have an account?")
            NavigationLink("Sign Up") {
                RegisterScreen()
            }
        }
    }

    @ViewBuilder private var logInButton: some View {
        CapsuleButton(text: "Log In") {
            Task {
                isLoading = true
                await logInViewModel.sigIn(email: mail, password: password)
                isLoading = false
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder private var forgotPasswordButton: some View {
        Button {
            isShowResetPassword.toggle()
        } label: {
            Text("Forgot password")
        }
        .padding(.top)

    }
}

#Preview {
    LoginScreen()
}
