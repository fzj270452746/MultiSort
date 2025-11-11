//
//  BaseModalController.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/11.
//

import UIKit

/// 通用弹窗基类，处理模态展示和动画
class BaseModalController: UIViewController {
    
    // MARK: - UI Elements
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let cardView = UIView()
    var gradientLayer: CAGradientLayer?
    
    // MARK: - Configuration
    var overlayAlpha: CGFloat = 0.3 // 用户偏好低透明度
    var cardCornerRadius: CGFloat = 24
    var cardHorizontalPadding: CGFloat = 28
    var animationDuration: TimeInterval = 0.3
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = cardView.bounds
    }
    
    // MARK: - Setup
    private func setupBaseAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(overlayAlpha)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupTapToDismiss()
        setupCardView()
    }
    
    private func setupTapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = cardCornerRadius
        cardView.layer.masksToBounds = true
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        
        gradientLayer = createGradientLayer()
        if let gradientLayer = gradientLayer {
            cardView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cardHorizontalPadding),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -cardHorizontalPadding)
        ])
    }
    
    private func createGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.17, green: 0.20, blue: 0.36, alpha: 0.9).cgColor,
            UIColor(red: 0.10, green: 0.14, blue: 0.25, alpha: 0.95).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    // MARK: - Animations
    func animateIn() {
        cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        cardView.alpha = 0
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut]) {
            self.blurView.alpha = 1
            self.cardView.alpha = 1
            self.cardView.transform = .identity
        }
    }
    
    func animateOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animationDuration * 0.8, delay: 0, options: [.curveEaseIn]) {
            self.blurView.alpha = 0
            self.cardView.alpha = 0
            self.cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            completion?()
        }
    }
    
    // MARK: - Actions
    @objc func backgroundTapped() {
        dismissModal()
    }
    
    func dismissModal() {
        animateOut { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    // MARK: - Helper Methods
    func createStyledButton(title: String, subtitle: String? = nil, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // 添加触摸效果
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        if let subtitle = subtitle {
            let attributedTitle = NSMutableAttributedString(
                string: "\(title)\n",
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
                ]
            )
            let detail = NSAttributedString(
                string: subtitle,
                attributes: [
                    .foregroundColor: UIColor.white.withAlphaComponent(0.75),
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                ]
            )
            attributedTitle.append(detail)
            button.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
        
        return button
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            sender.backgroundColor = UIColor.white.withAlphaComponent(0.22)
        }
    }
    
    @objc func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        }
    }
}

