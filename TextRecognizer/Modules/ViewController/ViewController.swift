//
//  ViewController.swift
//  TextRecognizer
//
//  Created by Владислав Пуцыкович on 11.03.22.
//

import AVFoundation
import Vision
import VisionKit

import UIKit
import SnapKit

fileprivate struct Constants {
    static let navigationTitle = "Scan and Listen"
}

final class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let buttonsStackView = UIStackView()
    private let scanButtonView = UIView()
    private let soundButton = SecondaryButton(buttonType: .play)
    private let scanButton = MainButton()
    private let clearButton = SecondaryButton(buttonType: .clear)
    
    private let textView = UITextView()
    
    private var listenService: ListenService
    private var scanService: ScanService
    
    // MARK: - App lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Init
    
    init(listenService: ListenService, scanService: ScanService) {
        self.listenService = listenService
        self.scanService = scanService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.title = Constants.navigationTitle
        view.backgroundColor = .white
        createButtons()
        createLabel()
        
        listenService.onChangedState = { [weak self] state in
            switch state {
            case .play:
                self?.soundButton.setImage(
                    ImageKey.pause.image?.withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
            case .pause:
                self?.soundButton.setImage(
                    ImageKey.listen.image?.withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
            }
        }
        
        scanService.onChangedText = { [weak self] text in
            self?.textView.text += text
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: UI elements
    
    private func createButtons() {
        view.addSubview(buttonsStackView)

        buttonsStackView.addArrangedSubview(soundButton)
        buttonsStackView.addArrangedSubview(scanButtonView)
        buttonsStackView.addArrangedSubview(clearButton)
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = view.frame.width / 10
        buttonsStackView.backgroundColor = .blueGreen
        
        soundButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.listenService.translateTextToSound(text: self?.textView.text ?? "")
                }
            ), for: .touchUpInside
        )
        
        scanButtonView.addSubview(scanButton)
        
        scanButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.presentScanner()
                }
            ), for: .touchUpInside
        )
        
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(view.frame.width / 4)
        }
        
        clearButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.textView.text = ""
                }
            ), for: .touchUpInside
        )
        
        buttonsStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(view.frame.height / 6)
            make.width.equalToSuperview()
        }
    }
    
    private func createLabel() {
        view.addSubview(textView)
        
        textView.delegate = self
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.font = .systemFont(ofSize: view.frame.width / 18)
        
        textView.text = "Tap button bellow to start recognize"
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(view.frame.height / 6)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Present document scanner
    
    private func presentScanner() {
        textView.text = ""
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = scanService
        present(scanner, animated: true)
    }
    
    // MARK: - Methods to control keyboard
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo!
        var rectValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        rectValue = textView.convert(rectValue, from: nil)
        textView.contentInset.bottom = rectValue.size.height
        textView.verticalScrollIndicatorInsets.bottom = rectValue.size.height
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        textView.contentInset = contentInsets
        textView.verticalScrollIndicatorInsets = contentInsets
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
