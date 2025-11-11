//
//  BaseViewController.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/11.
//

import UIKit

/// 基础视图控制器协议，定义共同行为
protocol ViewConfiguration {
    func assembleHierarchy()
    func configureAppearance()
    func establishConstraints()
}

/// 所有ViewController的基类，提取共同元素和行为
class BaseViewController: UIViewController, ViewConfiguration {
    
    // MARK: - Common UI Elements
    let backdropPortrayal = UIImageView()
    let overlayVeil = UIView()
    let retreatButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        assembleHierarchy()
        configureAppearance()
        establishConstraints()
    }
    
    // MARK: - ViewConfiguration Protocol (子类可重写)
    func assembleHierarchy() {
        view.addSubview(backdropPortrayal)
        view.addSubview(overlayVeil)
    }
    
    func configureAppearance() {
        configureBackdrop()
    }
    
    func establishConstraints() {
        setupBackdropConstraints()
    }
    
    // MARK: - Common Configuration
    func configureBackdrop() {
        backdropPortrayal.image = UIImage(named: "multiSortImage")
        backdropPortrayal.contentMode = .scaleAspectFill
        overlayVeil.backgroundColor = VibrantConstants.Palette.overlayDim
    }
    
    func setupBackdropConstraints() {
        backdropPortrayal.translatesAutoresizingMaskIntoConstraints = false
        overlayVeil.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropPortrayal.topAnchor.constraint(equalTo: view.topAnchor),
            backdropPortrayal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropPortrayal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropPortrayal.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayVeil.topAnchor.constraint(equalTo: view.topAnchor),
            overlayVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Common Button Configuration
    func configureRetreatButton(target: Any?, action: Selector) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let arrowImage = UIImage(systemName: "arrow.left.circle.fill", withConfiguration: configuration)
        retreatButton.setImage(arrowImage, for: .normal)
        retreatButton.tintColor = VibrantConstants.Palette.pureWhite
        retreatButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        retreatButton.layer.cornerRadius = 22
        retreatButton.applySubtleShadow()
        retreatButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addRetreatButton() {
        view.addSubview(retreatButton)
        retreatButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            retreatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            retreatButton.widthAnchor.constraint(equalToConstant: 44),
            retreatButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Common Actions
    @objc dynamic func retreatTapped() {
        navigationController?.popViewController(animated: true)
    }
}

