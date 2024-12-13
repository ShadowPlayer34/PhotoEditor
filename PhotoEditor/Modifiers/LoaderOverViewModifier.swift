//
//  LoaderOverViewModifier.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//


import SwiftUI

/// A modifier that displays loader above the view when the view is in the loading state.
struct LoaderOverViewModifier {

    /// Determines if is in loading state.
    let isLoading: Bool
}

extension LoaderOverViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .progressViewStyle(.circular)
            }
        }
    }
}

extension View {
    func withLoaderOverView(isLoading: Bool) -> some View {
        modifier(
            LoaderOverViewModifier(isLoading: isLoading)
        )
    }
}
