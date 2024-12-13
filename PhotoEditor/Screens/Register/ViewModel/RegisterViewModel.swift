//
//  RegisterViewModel.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import Combine
import SwiftUI
import FirebaseAuth

/// ViewModel responsible for handling user registration logic and state.
class RegisterViewModel: ObservableObject {

    private(set) var errorPublisher = CurrentValueSubject<String?, Never>(nil)
    private(set) var isRegisteredPublisher = CurrentValueSubject<Bool, Never>(false)

    /// Registers a new user with the provided email, password.
    func register(email: String, password: String, confirmPassword: String) async {
        let validator = Validator()
        do {
            guard password == confirmPassword else {
                throw RegistrationError.confirmPasswordMismatch
            }
            guard validator.isValidEmail(email) else {
                throw RegistrationError.wrongEmailFormat
            }
            guard validator.isValidPasswordLength(password) else {
                throw RegistrationError.shortPassword
            }
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            try await authResult.user.sendEmailVerification()
            isRegisteredPublisher.send(true)
        } catch {
            if let error = error as? RegistrationError {
                errorPublisher.send(error.description)
            } else {
                errorPublisher.send(error.localizedDescription)
            }
        }
    }
}

enum RegistrationError: Error {
    case wrongEmailFormat
    case shortPassword
    case confirmPasswordMismatch
    case unexpectedError
    case emailAlreadyExists

    var description: String {
        switch self {
        case .wrongEmailFormat:
            return "Invalid email format"
        case .shortPassword:
            return "Password must be at least 8 characters long"
        case .confirmPasswordMismatch:
            return "Passwords do not match"
        case .emailAlreadyExists:
            return "Email already exists"
        case .unexpectedError:
            return "Unexpected error occurred"
        }
    }
}
