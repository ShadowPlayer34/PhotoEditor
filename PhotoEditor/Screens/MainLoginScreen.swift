//
//  MainLoginScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import SwiftUI

struct MainLoginScreen {
    @State private var isLoading: Bool = false
}

extension MainLoginScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .navigationTitle("Sign In/Sign Up")
        }
        .withLoaderOverView(isLoading: isLoading)
    }
}

#Preview {
    MainLoginScreen()
}
