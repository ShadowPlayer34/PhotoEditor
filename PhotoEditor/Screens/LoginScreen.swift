//
//  MainLoginScreen.swift
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
    }

    private var inputTextFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $mail, prompt: "Mail")
            CustomTextField(text: $password, prompt: "Password", isSecure: true)
        }
        .padding(.top, 50)
    }

    private var socialLoginButton: some View {
        Button {
            // TODO: Implement
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
            Button("Sign Up") {
                // TODO: Implement
            }
        }
    }

    private var logInButton: some View {
        Button {
            Task {
                let _ = await logInViewModel.sigIn(email: mail, password: password)
            }
        } label: {
            Text("Log In")
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .background(Color.blue)
        .cornerRadius(50)
        .padding(.vertical)
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
