//
//  ImageKey.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 12.03.22.
//

import Foundation
import UIKit

enum ImageKey: String {
    case camera = "camera"
    case listen = "listen"
    case pause = "pause"
    case clear = "remove"
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
