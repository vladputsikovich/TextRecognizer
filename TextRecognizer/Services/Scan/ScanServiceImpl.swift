//
//  ScanServiceImpl.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 13.03.22.
//

import Vision
import VisionKit

class ScanServiceImpl: NSObject, ScanService {
    
    var onChangedText: ((String) -> Void)?
    
    // MARK: - Queue property
    
    lazy var workQueue = {
        return DispatchQueue(
            label: "workQueue",
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem
        )
    }()
    
    // MARK: - Text Recognition Request
    
    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let req = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var resultText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                resultText += topCandidate.string
                resultText += "\n"
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.onChangedText?(resultText)
            }
        }
        return req
    }()

    // MARK: - Scan
    
    func recognizeText(inImage: UIImage) {
        guard let cgImage = inImage.cgImage else { return }
        
        workQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Document Camera VC Delegate

extension ScanServiceImpl {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for i in 0 ..< scan.pageCount {
            let img = scan.imageOfPage(at: i)
            recognizeText(inImage: img)
        }
        
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
}
