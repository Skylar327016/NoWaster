
import SwiftUI
import VisionKit
import Vision
// MARK: - https://medium.com/swlh/on-device-text-recognition-on-ios-with-swiftui-dd499b9eec0b

struct ScanDocumentView: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: InventoryAdditionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $viewModel.name, parent: self)
    }
}

class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
  
    var recognizedText: Binding<String>
    var parent: ScanDocumentView
    
    init(recognizedText: Binding<String>, parent: ScanDocumentView) {
        self.recognizedText = recognizedText
        self.parent = parent
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // do the processing of the scan
        let extractedImages = extractImages(from: scan)
        let processedText = recognizeText(from: extractedImages)
        recognizedText.wrappedValue = processedText
        parent.viewModel.showingScanView = false
        parent.presentationMode.wrappedValue.dismiss()
    }
    
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        parent.viewModel.showingScanView = false
    }
    
    
    fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
        var extractedImages = [CGImage]()
        for index in 0..<scan.pageCount {
            let extractedImage = scan.imageOfPage(at: index)
            guard let cgImage = extractedImage.cgImage else { continue }

            extractedImages.append(cgImage)
        }
        return extractedImages
    }
    
    
    fileprivate func recognizeText(from images: [CGImage]) -> String {
        var entireRecognizedText = ""
        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
            guard error == nil else { return }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let maximumRecognitionCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                
                entireRecognizedText += "\(candidate.string) "
                
            }
        }
        recognizeTextRequest.recognitionLevel = .accurate
        
        for image in images {
            let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
            
            try? requestHandler.perform([recognizeTextRequest])
        }
        
        return entireRecognizedText
    }
}

