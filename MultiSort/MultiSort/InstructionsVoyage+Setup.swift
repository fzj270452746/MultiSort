//
//  InstructionsVoyage+Setup.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension InstructionsVoyage {
    
    func configureTitle() {
        titleLabel.text = VibrantConstants.Text.instructionsTitle
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = VibrantConstants.Palette.pureWhite
        titleLabel.textAlignment = .center
        titleLabel.applyRadiantShadow()
    }
    
    func configureScrollView() {
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
    
    func setupInstructionsConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollVessel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        instructionsText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
}

