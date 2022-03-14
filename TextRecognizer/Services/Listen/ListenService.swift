//
//  ListenService.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 12.03.22.
//

import AVFoundation

protocol ListenService: AVSpeechSynthesizerDelegate {
    var onChangedState: ((ListenStates) -> ())? { get set }
    func initialize()
    func translateTextToSound(text: String)
}
