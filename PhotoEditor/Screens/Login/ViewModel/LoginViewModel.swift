//
//  LogInViewModel.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import Firebase
import FirebaseAuth
import GoogleSignIn

struct LogInViewModel {

    var isLoggedIn: Bool = false

    func sigIn(email: String, password: String) async -> Result<Void, Error> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func resetPassword(email: String) {
        
    }

    func signInWithGoogle() async {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        //get rootView
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = await scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }

        do {
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
        } catch {

        }
    }
}

enum AuthenticationError: Error {
    case invalidCredentials
    case invalidToken
    case unexpectedError
}
