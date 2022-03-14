//
//  ScanService.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 13.03.22.
//

import Vision
import VisionKit

protocol ScanService: VNDocumentCameraViewControllerDelegate {
    var onChangedText: ((String) -> Void)? { get set }
    func recognizeText(inImage: UIImage)
}
