//
//  CapsuleStyle.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI

/// A view modifier that applies a capsule-shaped style
struct CapsuleStyle: ViewModifier {

    /// Background color of the capsule.
    var backgroundColor: Color = .clear

    /// Foreground color of the content.
    var foregroundColor: Color = .white

    /// Width of the capsule's border.
    var borderWidth: CGFloat = 2

    /// Color of the capsule's border.
    var borderColor: Color = .black

    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(borderColor, lineWidth: borderWidth)
            }
            .foregroundColor(foregroundColor)
    }
}

extension View {

    /// Applies a capsule style to the view.
    func capsuleStyle(
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        borderWidth: CGFloat = 0,
        borderColor: Color = .black
    ) -> some View {
        self.modifier(CapsuleStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            borderWidth: borderWidth,
            borderColor: borderColor
        ))
    }
}

#Preview {
    Button("Test this button") {

    }
    .capsuleStyle()
}
