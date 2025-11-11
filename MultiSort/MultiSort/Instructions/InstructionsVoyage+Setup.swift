//
//  InstructionsVoyage+Setup.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension InstructionsVoyage {
    
    func assembleHierarchy() {
        view.addSubview(backdropPortrayal)
        view.addSubview(overlayVeil)
        view.addSubview(retreatButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollVessel)
        scrollVessel.addSubview(contentContainer)
        contentContainer.addSubview(instructionsText)
    }
    
    func configureAppearance() {
        configureBackdrop()
        configureRetreatButton()
        configureTitleLabel()
        configureScrollVessel()
        configureInstructionsText()
    }
    
    func configureBackdrop() {
        backdropPortrayal.image = UIImage(named: "multiSortImage")
        backdropPortrayal.contentMode = .scaleAspectFill
        
        overlayVeil.backgroundColor = VibrantConstants.Palette.overlayDim
    }
    
    func configureRetreatButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let arrowImage = UIImage(systemName: "arrow.left.circle.fill", withConfiguration: configuration)
        retreatButton.setImage(arrowImage, for: .normal)
        retreatButton.tintColor = VibrantConstants.Palette.pureWhite
        retreatButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        retreatButton.layer.cornerRadius = 22
        retreatButton.applySubtleShadow()
        retreatButton.addTarget(self, action: #selector(retreatTapped), for: .touchUpInside)
    }
    
    func configureTitleLabel() {
        titleLabel.text = VibrantConstants.Text.instructionsTitle
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = VibrantConstants.Palette.pureWhite
        titleLabel.textAlignment = .center
        titleLabel.applyRadiantShadow()
    }
    
    func configureScrollVessel() {
        scrollVessel.showsVerticalScrollIndicator = false
    }
    
    func configureInstructionsText() {
        instructionsText.text = VibrantConstants.Text.instructionsContent
        instructionsText.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        instructionsText.textColor = VibrantConstants.Palette.pureWhite
        instructionsText.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        instructionsText.layer.cornerRadius = VibrantConstants.Measurements.cornerRadius
        instructionsText.isEditable = false
        instructionsText.isSelectable = false
        instructionsText.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        instructionsText.applySubtleShadow()
    }
    
    func establishConstraints() {
        backdropPortrayal.translatesAutoresizingMaskIntoConstraints = false
        overlayVeil.translatesAutoresizingMaskIntoConstraints = false
        retreatButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollVessel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        instructionsText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropPortrayal.topAnchor.constraint(equalTo: view.topAnchor),
            backdropPortrayal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropPortrayal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropPortrayal.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayVeil.topAnchor.constraint(equalTo: view.topAnchor),
            overlayVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            retreatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            retreatButton.widthAnchor.constraint(equalToConstant: 44),
            retreatButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollVessel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scrollVessel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollVessel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollVessel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentContainer.topAnchor.constraint(equalTo: scrollVessel.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollVessel.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollVessel.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollVessel.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollVessel.widthAnchor),
            
            instructionsText.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            instructionsText.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            instructionsText.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            instructionsText.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -VibrantConstants.Measurements.padding),
            instructionsText.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        ])
    }
    
    @objc func retreatTapped() {
        retreatButton.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

