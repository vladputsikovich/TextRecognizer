//
//  ListenServiceImpl.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 12.03.22.
//

import AVFoundation

enum ListenStates {
    case play
    case pause
}

class ListenServiceImpl: NSObject, ListenService {
    
    let synthesizer = AVSpeechSynthesizer ()
    
    override init() {
        super.init()
        self.initialize()
    }
    
    func initialize() {
        synthesizer.delegate = self
    }
    
    var onChangedState: ((ListenStates) -> ())?
    
    func translateTextToSound(text: String) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            onChangedState?(.play)
        }
        
        else if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            onChangedState?(.pause)
        }
        
        else if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.3
        
            synthesizer.speak(utterance)
            onChangedState?(.pause)
        }
    }
}

extension ListenServiceImpl {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onChangedState?(.play)
    }
}
