//
//  PhotoPickerView.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import PhotosUI
import SwiftUI

extension PHPickerViewController {
    struct View: UIViewControllerRepresentable {
        var configuration: PHPickerConfiguration
        var onSelect: (PHPickerResult?) -> Void

        func makeUIViewController(context: Context) -> PHPickerViewController {
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(onSelect: onSelect)
        }

        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            var onSelect: (PHPickerResult?) -> Void

            init(onSelect: @escaping (PHPickerResult?) -> Void) {
                self.onSelect = onSelect
            }

            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                onSelect(results.first)
            }
        }
    }
}
