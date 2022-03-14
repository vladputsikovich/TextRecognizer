//
//  SecondaryButton.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 14.03.22.
//

import Foundation
import UIKit

enum TypeButton {
    case clear
    case play
    case pause
    
    var image: UIImage? {
        switch self {
        case .clear:
            return ImageKey.clear.image
        case .play:
            return ImageKey.listen.image
        case .pause:
            return ImageKey.pause.image
        }
    }
}

class SecondaryButton: UIButton {
    
    private var type: TypeButton
    
    init(buttonType: TypeButton) {
        self.type = buttonType
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setImage(type.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .white
    }
}
