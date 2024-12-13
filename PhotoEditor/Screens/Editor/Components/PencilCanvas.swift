//
//  PencilCanvas.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 13/12/24.
//

import PencilKit
import SwiftUI

struct PencilCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
