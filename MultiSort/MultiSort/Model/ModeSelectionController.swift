//
//  ModeSelectionController.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/6.
//

import UIKit

class ModeSelectionController: UIViewController {
    var onSelect: ((GameVariant) -> Void)?
    var onCancel: (() -> Void)?
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let optionsStack = UIStackView()
    private let cancelButton = UIButton(type: .system)
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBaseAppearance()
        assembleHierarchy()
        configureContent()
        layoutContent()
        animateIn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = cardView.bounds
    }
    
    private func configureBaseAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    private func assembleHierarchy() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 24
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        gradientLayer = makeGradientLayer()
        if let gradientLayer {
            cardView.layer.insertSublayer(gradientLayer, at: 0)
        }
        view.addSubview(cardView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStack.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(optionsStack)
        cardView.addSubview(cancelButton)
    }
    
    private func configureContent() {
        titleLabel.text = "Select Game Mode"
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .white
        
        subtitleLabel.text = "Choose how you’d like to sort the tiles."
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subtitleLabel.numberOfLines = 0
        
        optionsStack.axis = .vertical
        optionsStack.spacing = 14
        optionsStack.alignment = .fill
        
        for (index, variant) in GameVariant.allCases.enumerated() {
            let optionButton = createOptionButton(for: variant)
            optionButton.tag = index
            optionsStack.addArrangedSubview(optionButton)
        }
        
        cancelButton.setTitle("Maybe Later", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        cancelButton.layer.cornerRadius = 16
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    private func layoutContent() {
        let cardLeadingTrailing: CGFloat = 28
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cardLeadingTrailing),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -cardLeadingTrailing)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            optionsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            optionsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            optionsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: optionsStack.bottomAnchor, constant: 24),
            cancelButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
    }
    
    private func createOptionButton(for variant: GameVariant) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(modeButtonTapped(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(modeButtonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(modeButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        let title = NSMutableAttributedString(
            string: "\(variant.displayName)\n",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
            ]
        )
        let detail = NSAttributedString(
            string: variant.descriptiveBlurb,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.75),
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
        title.append(detail)
        button.setAttributedTitle(title, for: .normal)
        
        return button
    }
    
    private func makeGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.17, green: 0.20, blue: 0.36, alpha: 0.9).cgColor,
            UIColor(red: 0.10, green: 0.14, blue: 0.25, alpha: 0.95).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    private func animateIn() {
        cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        cardView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.blurView.alpha = 1
            self.cardView.alpha = 1
            self.cardView.transform = .identity
        }
    }
    
    private func animateOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
            self.blurView.alpha = 0
            self.cardView.alpha = 0
            self.cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            completion?()
        }
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
    
    @objc private func modeButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            sender.backgroundColor = UIColor.white.withAlphaComponent(0.22)
        }
    }
    
    @objc private func modeButtonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        }
    }
    
    @objc private func cancelTapped() {
        animateOut { [weak self] in
            self?.dismiss(animated: false) {
                self?.onCancel?()
            }
        }
    }
}

