//
//  LoginViewModel.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import Combine
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewModel: ObservableObject {

    private(set) var isLoggedInPublisher = CurrentValueSubject<Bool, Never>(false)
    private(set) var errorPublisher = CurrentValueSubject<AuthenticationError?, Never>(nil)
    private(set) var isPasswordResetPublisher = CurrentValueSubject<Bool, Never>(false)

    private let validator = Validator()

    func sigIn(email: String, password: String) async {
        do {
            guard validator.isValidEmail(email) else {
                throw AuthenticationError.wrongEmailFormat
            }

            guard validator.isValidPasswordLength(password) else {
                throw AuthenticationError.shortPassword
            }

            try await Auth.auth().signIn(withEmail: email, password: password)
            isLoggedInPublisher.send(true)
        } catch {
            if let error = error as? AuthenticationError {
                errorPublisher.send(error)
            } else {
                errorPublisher.send(AuthenticationError.unexpectedError)
            }
            return
        }
    }

    func signInWithGoogle() async {
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                print("no firbase clientID found")
                throw AuthenticationError.unexpectedError
            }

            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            //get rootView
            let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootViewController = await scene?.windows.first?.rootViewController
            else {
                print("There is no root view controller!")
                throw AuthenticationError.unexpectedError
            }

            //google sign in authentication response
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController
            )
            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                throw AuthenticationError.unexpectedError
            }

            //Firebase auth
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken, accessToken: user.accessToken.tokenString
            )
            try await Auth.auth().signIn(with: credential)
            isLoggedInPublisher.send(true)
        } catch {
            if let error = error as? AuthenticationError {
                errorPublisher.send(error)
            } else {
                errorPublisher.send(AuthenticationError.unexpectedError)
            }
            return
        }
    }

    func resetPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            isPasswordResetPublisher.send(true)
        } catch {
            errorPublisher.send(AuthenticationError.resetPasswordError)
            return
        }
    }
}

enum AuthenticationError: Error {
    case invalidCredentials
    case wrongEmailFormat
    case shortPassword
    case invalidToken
    case unexpectedError
    case wrongPassword
    case wrongEmail
    case resetPasswordError

    var description: String {
        switch self {
        case .invalidCredentials:
            return "The credentials are invalid. Please try again."
        case .wrongEmailFormat:
            return "The email format is incorrect. Please enter a valid email."
        case .shortPassword:
            return "The password is too short. It must be at least 8 characters."
        case .wrongEmail:
            return "The email is incorrect. Please enter a valid email."
        case .wrongPassword:
            return "The password is incorrect. Please try again."
        case .invalidToken:
            return "Invalid token. Please try again."
        case .resetPasswordError:
            return "An error occurred while resetting your password. Please try again."
        case .unexpectedError:
            return "An unexpected error occurred. Please try again later."
        }
    }
}
