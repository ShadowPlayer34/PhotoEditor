//
//  View+hideKeyboard.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 13/12/24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
