//
//  Validator.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 13/12/24.
//

import Foundation

struct Validator {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPasswordLength(_ password: String) -> Bool {
        return password.count >= 8
    }
}
