//
//  UIButton.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 14.03.22.
//

import Foundation
import UIKit

class MainButton: UIButton {
    
    var onTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setImage(ImageKey.camera.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .systemGray
        tintColor = .white
        addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.onTapped?()
                }
            ),
            for: .touchUpInside
        )
    }
}
