//
//  ModeSelectionController.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/6.
//

import UIKit

class ModeSelectionController: BaseModalController {
    var onSelect: ((GameVariant) -> Void)?
    var onCancel: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let optionsStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleHierarchy()
        configureContent()
        layoutContent()
        animateIn()
    }
    
    private func assembleHierarchy() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(optionsStack)
    }
    
    private func configureContent() {
        titleLabel.text = "Select Game Mode"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        optionsStack.axis = .vertical
        optionsStack.spacing = 12
        optionsStack.alignment = .fill
        
        for (index, variant) in GameVariant.allCases.enumerated() {
            let optionButton = createOptionButton(for: variant)
            optionButton.tag = index
            optionsStack.addArrangedSubview(optionButton)
        }
    }
    
    private func layoutContent() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            optionsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            optionsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            optionsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            optionsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }
    
    private func createOptionButton(for variant: GameVariant) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        button.setTitle(variant.displayName, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(modeButtonTapped(_:)), for: .touchUpInside)
        
        // 使用父类的触摸效果方法
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    @objc private func modeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < GameVariant.allCases.count else { return }
        let variant = GameVariant.allCases[index]
        animateOut { [weak self] in
            self?.dismiss(animated: false) {
                self?.onSelect?(variant)
            }
        }
    }
    
    override func backgroundTapped() {
        animateOut { [weak self] in
            self?.dismiss(animated: false) {
                self?.onCancel?()
            }
        }
    }
}

