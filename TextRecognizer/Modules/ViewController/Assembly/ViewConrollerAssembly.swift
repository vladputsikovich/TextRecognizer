//
//  ViewConrollerAssembly.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 13.03.22.
//

import Foundation

class ViewControllerAssembly {
    func assembly() -> ViewController {
        return ViewController(listenService: ListenServiceImpl(), scanService: ScanServiceImpl())
    }
}
