//
//  PhotoEditorApp.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import SwiftUI
import Combine
import GoogleSignIn
import FirebaseAuth

@main
struct PhotoEditorApp: App {

    @State private var userLoggedIn: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    @ObservedObject private var mainViewRouter = MainViewRouter()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !userLoggedIn {
                    LoginScreen()
                        .environmentObject(mainViewRouter)
                } else {
                    PhotoEditorScreen()
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .onAppear{
                let _ = Auth.auth().addStateDidChangeListener{ auth, user in
                    if (user != nil) {
                        mainViewRouter.isUserLoggedInPublisher.send(true)
                    } else {
                        mainViewRouter.isUserLoggedInPublisher.send(false)
                    }
                }
                mainViewRouter.isUserLoggedInPublisher
                    .sink { isLoggedIn in
                        userLoggedIn = isLoggedIn
                    }
                    .store(in: &cancellables)
            }
        }
    }
}
