//
//  WelcomeVoyage+Hierarchy.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension WelcomeVoyage {
    
    func setupTitleAndStackConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            
            containerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            containerStack.widthAnchor.constraint(lessThanOrEqualToConstant: 500),
            
            startButton.heightAnchor.constraint(equalToConstant: 65),
            instructionsButton.heightAnchor.constraint(equalToConstant: 65),
            recordsButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}

