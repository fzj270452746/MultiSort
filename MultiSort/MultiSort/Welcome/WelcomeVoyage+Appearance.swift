//
//  WelcomeVoyage+Appearance.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension WelcomeVoyage {
    
    func configureAppearance() {
        configureBackdrop()
        configureTitleLabel()
        configureContainerStack()
        configureButtons()
    }
    
    func configureBackdrop() {
        backdropPortrayal.image = UIImage(named: "multiSortImage")
        backdropPortrayal.contentMode = .scaleAspectFill
        
        overlayVeil.backgroundColor = VibrantConstants.Palette.overlayDim
    }
    
    func configureTitleLabel() {
        titleLabel.text = VibrantConstants.Text.appTitle
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        titleLabel.textColor = VibrantConstants.Palette.pureWhite
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.applyRadiantShadow()
    }
    
    func configureContainerStack() {
        containerStack.axis = .vertical
        containerStack.spacing = 20
        containerStack.distribution = .fillEqually
        containerStack.alignment = .fill
    }
    
    func configureButtons() {
        configureEnhancedButton(
            startButton,
            title: VibrantConstants.Text.startGame,
            iconName: "",
            backgroundColor: VibrantConstants.Palette.primaryTint,
            action: #selector(startGameTapped)
        )
        
        configureEnhancedButton(
            instructionsButton,
            title: VibrantConstants.Text.instructions,
            iconName: "",
            backgroundColor: VibrantConstants.Palette.accentTint,
            action: #selector(instructionsTapped)
        )
        
        configureEnhancedButton(
            recordsButton,
            title: VibrantConstants.Text.records,
            iconName: "",
            backgroundColor: VibrantConstants.Palette.secondaryTint,
            action: #selector(recordsTapped)
        )
    }
    
    func configureEnhancedButton(_ button: UIButton, title: String, iconName: String, backgroundColor: UIColor, action: Selector) {
        // 配置按钮基础样式
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        button.layer.masksToBounds = false
        
        // 添加渐变效果
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            backgroundColor.cgColor,
            backgroundColor.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 16
        
        // 移除旧的渐变层（如果存在）
        button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // 配置按钮图标和文字（iOS 14 兼容方式）
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold)
        let icon = UIImage(systemName: iconName, withConfiguration: iconConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(icon, for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.tintColor = .white
        
        // 设置图标和文字的间距
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // 添加高亮效果
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.8
        }
    }
    
    @objc func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
}

