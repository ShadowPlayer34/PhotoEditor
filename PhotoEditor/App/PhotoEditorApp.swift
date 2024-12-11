//
//  PhotoEditorApp.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import SwiftUI

@main
struct YourApp: App {

  // Register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
          MainLoginScreen()
      }
    }
  }
}
