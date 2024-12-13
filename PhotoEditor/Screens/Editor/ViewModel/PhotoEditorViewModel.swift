//
//  PhotoEditorViewModel.swift
//  PhotoEditor
//
//  Created by Andrew Hudik on 12/12/24.
//

import SwiftUI
import PhotosUI
import PencilKit
import FirebaseAuth

/// ViewModel for managing photo editing operations in the PhotoEditor.
class PhotoEditorViewModel: ObservableObject {

    /// Holds the current image to be edited.
    @Published var image: UIImage? = nil

    /// Tracks loading state for image processing.
    @Published var isLoading: Bool = false

    /// Controls whether drawing on the canvas is enabled.
    @Published var isDrawingEnabled: Bool = true

    /// Holds an error message, if any.
    @Published var errorMessage: String? = nil

    /// The canvas for drawing annotations on the image.
    @Published var canvasView = PKCanvasView()

    private var appliedFilter: CIFilter? = nil
    private var originalImage: UIImage? = nil

    /// Loads an image from the PHPickerResult and initializes the canvas size.
    func loadImage(from result: PHPickerResult) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to load image: \(error.localizedDescription)"
                    return
                }
                guard let image = object as? UIImage else {
                    self?.errorMessage = "Invalid image format."
                    return
                }
                self?.image = image
                self?.originalImage = image // Save the original image
                self?.canvasView.frame = CGRect(origin: .zero, size: image.size)
                self?.canvasView.contentSize = image.size
            }
        }
    }

    /// Saves the edited image by combining the base image and any drawing annotations.
    func saveEditedImage() -> UIImage? {
        isLoading = true
        guard let baseImage = image else { return nil }
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)

        return renderer.image { context in
            context.cgContext.translateBy(x: 0, y: baseImage.size.height)
            context.cgContext.scaleBy(x: 1, y: -1)

            if let cgImage = baseImage.cgImage {
                context.cgContext.draw(cgImage, in: CGRect(origin: .zero, size: baseImage.size))
            }

            let drawing = canvasView.drawing.image(from: canvasView.bounds, scale: baseImage.scale)
            context.cgContext.draw(drawing.cgImage!, in: CGRect(origin: .zero, size: baseImage.size))

            isLoading = false
        }
    }

    /// Applies a filter to the original image and updates the displayed image.
    func applyFilter(_ filter: CIFilter) {
        guard let image = originalImage else { return }
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        if let output = filter.outputImage,
           let cgImage = CIContext().createCGImage(output, from: output.extent) {
            self.image = UIImage(cgImage: cgImage)
            self.appliedFilter = filter
        }
    }

    /// Rotates the current image by the specified number of degrees.
    func rotateImage(by degrees: CGFloat) {
        isLoading = true
        guard let image = image else { return }

        let ciImage = CIImage(image: image)
        let transform = CGAffineTransform(rotationAngle: .pi * degrees / 180.0)
        let outputCIImage = ciImage!.transformed(by: transform)

        if let cgImage = CIContext().createCGImage(outputCIImage, from: outputCIImage.extent) {
            self.image = UIImage(cgImage: cgImage)
        }
        isLoading = false
    }

    /// Scales the current image by the specified factor.
    func scaleImage(by factor: CGFloat) {
        isLoading = true
        guard let image = originalImage else { return }

        let newWidth = image.size.width * factor
        let newHeight = image.size.height * factor
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.image = scaledImage

        isLoading = false
    }

    /// Resets all filters applied to the image and restores the original image.
    func resetFilters() {
        guard let originalImage = originalImage else { return }
        self.image = originalImage
        self.appliedFilter = nil
    }


    /// Presents the share sheet to allow sharing of the edited image.
    func shareImage(image: UIImage) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let rootViewController = windowScene?.windows.first?.rootViewController else { return }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)


        activityViewController.excludedActivityTypes = [.postToTwitter, .postToFacebook]
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }

    /// Logs out the current user from Firebase.
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "Can't logout"
        }
    }
}
