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
    
    // MARK: - Properties
    
    private var type: TypeButton
    
    var onTapped: (() -> Void)?
    
    // MARK: - Init
    
    init(buttonType: TypeButton) {
        self.type = buttonType
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        setImage(type.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.onTapped?()
                }
            ),
            for: .touchUpInside
        )
        tintColor = .white
    }
}
