//
//  EditorScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI

struct EditorScreen {
    @ObservedObject private var editorViewModel: EditorViewModel = EditorViewModel()
    @State private var isShowPhotoLibrary: Bool = false
    @State private var isShowCamera: Bool = false
    @State private var image: UIImage?
}

// TODO: Provide good description usage
extension EditorScreen: View {
    var body: some View {
        if image == nil {
            VStack(spacing: 20) {
                Button("Load your image") {
                    isShowPhotoLibrary.toggle()
                }
                Text("Or")
                Button("Take a photo") {
                    isShowCamera.toggle()
                }
            }
            .sheet(isPresented: $isShowPhotoLibrary) {
                PhotoPickerView(image: $image)
            }
            .sheet(isPresented: $isShowCamera) {
                CameraView(selectedImage: $image)
            }
        } else {
            if let image {
                Image(uiImage: image)
            }
        }
    }
}

#Preview {
    EditorScreen()
}
