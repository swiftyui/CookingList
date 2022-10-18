import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
      
        private let parent: PhotoPicker
        private let selectedImage: UIImage
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
            self.selectedImage = UIImage()
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            // Set isPresented to false because picking has finished.
            parent.isPresented = false
            //return the result
            let itemProvider = results.first?.itemProvider
            itemProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                if let image = image {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as! UIImage
                    }
                }
            })
        }
    }
}
