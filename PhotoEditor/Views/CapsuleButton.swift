//
//  CustomButton.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI

/// Custom button.
struct CapsuleButton {

    var text: String

    /// Button background color.
    var backgroundColor: Color = Color.blue

    /// Button foreground color.
    var foregroundColor: Color = Color.white

    /// Perfoms when user taps on button.
    var onTap: () -> Void
}

extension CapsuleButton: View {
    var body: some View {
        Button(action: onTap) {
            Text(text)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .capsuleStyle(
            backgroundColor: .blue,
            foregroundColor: .white
        )
    }
}

#Preview {
    CapsuleButton(text: "Log In") {

    }
}
