//
//  RegisterViewModel.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import FirebaseAuth

struct RegisterViewModel {
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // TODO: Implement
        }
    }
}
