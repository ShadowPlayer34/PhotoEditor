//
//  Validator.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 13/12/24.
//

import Foundation

/// A struct responsible for validating.
struct Validator {

    /// Validates the format of an email address using a regular expression.
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// Validates whether the password has a length of at least 8 characters.
    func isValidPasswordLength(_ password: String) -> Bool {
        return password.count >= 8
    }
}
