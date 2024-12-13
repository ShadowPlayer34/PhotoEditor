//  PhotoEditorScreen.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/13/24.

import SwiftUI
import Combine
import PhotosUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct PhotoEditorScreen {
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingErrorAlert = false
    @State private var selectedFilter: CIFilter = CIFilter.sepiaTone()
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0

    @ObservedObject private var viewModel = PhotoEditorViewModel()
}

extension PhotoEditorScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if let image = viewModel.image {
                    editorView(image: image)
                } else {
                    Text("Select an image to start editing")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
                VStack(spacing: 10) {
                    importExportButtons
                    instrumentButtons
                    rotationButtons
                }
            }
            .padding()
            .navigationTitle("Photo Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let image = viewModel.image {
                            viewModel.shareImage(image: image)
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(viewModel.image == nil)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Log Out") {
                        viewModel.logOut()
                    }
                }
            })
            .sheet(isPresented: $showingImagePicker) {
                PHPickerViewController.View(
                    configuration: PHPickerConfiguration(photoLibrary: .shared()),
                    onSelect: { result in
                        if let result = result {
                            viewModel.loadImage(from: result)
                        }
                    }
                )
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(selectedImage: $viewModel.image)
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onReceive(viewModel.$errorMessage.compactMap { $0 }) { _ in
                showingErrorAlert = true
            }
        }
        .withLoaderOverView(isLoading: viewModel.isLoading)
    }

    @ViewBuilder private func editorView(image: UIImage) -> some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                PencilCanvas(canvasView: $viewModel.canvasView)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.clear)
                    .allowsHitTesting(viewModel.isDrawingEnabled)
            }
            .scaleEffect(currentScale * finalScale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentScale = value
                    }
                    .onEnded { value in
                        finalScale *= currentScale
                        currentScale = 1.0
                    }
            )
        }
    }

    @ViewBuilder private var instrumentButtons: some View {
        HStack {
            Button(viewModel.isDrawingEnabled ? "Disable Drawing" : "Enable Drawing") {
                viewModel.isDrawingEnabled.toggle()
            }
            .buttonStyle(.bordered)
            Menu("Filters") {
                Button("Sepia") {
                    selectedFilter = CIFilter.sepiaTone()
                    viewModel.applyFilter(selectedFilter)
                }
                Button("Mono") {
                    selectedFilter = CIFilter.photoEffectMono()
                    viewModel.applyFilter(selectedFilter)
                }
                Button("Noir") {
                    selectedFilter = CIFilter.photoEffectNoir()
                    viewModel.applyFilter(selectedFilter)
                }
                Button("Reset Filters") {
                    viewModel.resetFilters()
                }
            }
            .buttonStyle(.bordered)
        }
    }

    @ViewBuilder private var importExportButtons: some View {
        HStack {
            Button("Load Image") {
                showingImagePicker.toggle()
            }
            .buttonStyle(.borderedProminent)

            Button("Camera") {
                showingCamera.toggle()
            }
            .buttonStyle(.borderedProminent)

            Button("Save Image") {
                if let editedImage = viewModel.saveEditedImage() {
                    UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.image == nil)
        }
    }

    @ViewBuilder private var rotationButtons: some View {
        HStack {
            Button(action: {
                viewModel.rotateImage(by: 90)
            }) {
                Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90")
            }
            .foregroundColor(.blue)

            Button(action: {
                viewModel.rotateImage(by: -90)
            }) {
                Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
            }
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    PhotoEditorScreen()
}
