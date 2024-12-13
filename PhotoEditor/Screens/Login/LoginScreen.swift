//
//  LoginScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import Firebase

struct LoginScreen {
    @State private var isLoading: Bool = false
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var isShowPassword: Bool = false
    @State private var isShowAlert: Bool = false

    private var logInViewModel: LogInViewModel = LogInViewModel()
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
            Alert(title: Text("Error"), message: Text("Unexpected error"))
        }
    }

    private var inputTextFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $mail, prompt: "Mail")
            HStack {
                // TODO: Fix resizing
                CustomTextField(text: $password, prompt: "Password", isSecure: !isShowPassword)
                Button {
                    isShowPassword.toggle()
                } label: {
                    Text("Show")
                }
            }
        }
        .padding(.top, 50)
    }

    private var socialLoginButton: some View {
        Button {
            Task {
                await logInViewModel.signInWithGoogle()
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

    private var signUpButton: some View {
        HStack {
            Text("Don't have an account?")
            NavigationLink("Sign Up") {
                RegisterScreen()
            }
        }
    }

    private var logInButton: some View {
        CustomButton(text: "Log In") {
            Task {
                let _ = await logInViewModel.sigIn(email: mail, password: password)
            }
        }
    }

    private var forgotPasswordButton: some View {
        Button {
            // TODO: Implement
        } label: {
            Text("Forgot password")
        }
        .padding(.top)

    }
}

#Preview {
    LoginScreen()
}
