//
//  CustomTextField.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 11/12/24.
//

import SwiftUI

/// Custom text field.
struct CapsuleTextField {

    /// Text field text.
    @Binding var text: String

    /// Defines border line color.
    var lineColor: Color = .primary

    /// Prompt that shows in the text field.
    var prompt: String = "Enter smth"

    var isSecure: Bool = false
}

extension CapsuleTextField: View {
    var body: some View {
        if !isSecure {
            TextField(prompt, text: $text)
                .capsuleStyle(
                    backgroundColor: .clear,
                    foregroundColor: .primary,
                    borderWidth: 1,
                    borderColor: .primary
                )
        } else {
            SecureField(prompt, text: $text)
                .capsuleStyle(
                    backgroundColor: .clear,
                    foregroundColor: .primary,
                    borderWidth: 1,
                    borderColor: .primary
                )
        }
    }
}

#Preview {
    @State var text: String = ""
    CapsuleTextField(text: $text)
}
