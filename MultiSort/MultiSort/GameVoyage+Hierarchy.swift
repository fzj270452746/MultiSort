//
//  GameVoyage+Hierarchy.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension GameVoyage {
    
    func assembleHierarchy() {
        view.addSubview(backdropPortrayal)
        view.addSubview(overlayVeil)
        view.addSubview(retreatButton)
        view.addSubview(timerLabel)
        view.addSubview(scoreLabel)
        view.addSubview(variantBadgeLabel)
        view.addSubview(objectiveBoard)
        view.addSubview(moveQuotaLabel)
        if variant.usesSuitCycler {
            view.addSubview(suitSwitcherButton)
        }
        view.addSubview(commandRibbon)
    }
    
    func establishConstraints() {
        backdropPortrayal.translatesAutoresizingMaskIntoConstraints = false
        overlayVeil.translatesAutoresizingMaskIntoConstraints = false
        retreatButton.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        variantBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        objectiveBoard.translatesAutoresizingMaskIntoConstraints = false
        moveQuotaLabel.translatesAutoresizingMaskIntoConstraints = false
        commandRibbon.translatesAutoresizingMaskIntoConstraints = false
        if variant.usesSuitCycler {
            suitSwitcherButton.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            
            scoreLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            
            variantBadgeLabel.leadingAnchor.constraint(equalTo: retreatButton.trailingAnchor, constant: 12),
            variantBadgeLabel.trailingAnchor.constraint(lessThanOrEqualTo: timerLabel.leadingAnchor, constant: -12),
            variantBadgeLabel.topAnchor.constraint(equalTo: retreatButton.topAnchor),
            
            objectiveBoard.topAnchor.constraint(equalTo: variantBadgeLabel.bottomAnchor, constant: 8),
            objectiveBoard.leadingAnchor.constraint(equalTo: variantBadgeLabel.leadingAnchor),
            objectiveBoard.trailingAnchor.constraint(lessThanOrEqualTo: timerLabel.leadingAnchor, constant: -12),
            
            moveQuotaLabel.topAnchor.constraint(equalTo: objectiveBoard.bottomAnchor, constant: 8),
            moveQuotaLabel.leadingAnchor.constraint(equalTo: variantBadgeLabel.leadingAnchor),
            moveQuotaLabel.trailingAnchor.constraint(lessThanOrEqualTo: timerLabel.leadingAnchor, constant: -12),
            
            commandRibbon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            commandRibbon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            commandRibbon.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -VibrantConstants.Measurements.padding),
            commandRibbon.heightAnchor.constraint(equalToConstant: VibrantConstants.Measurements.buttonHeight)
        ])
        
        if variant.usesSuitCycler {
            suitSwitcherConstraints = [
                suitSwitcherButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 12),
                suitSwitcherButton.leadingAnchor.constraint(equalTo: retreatButton.leadingAnchor),
                suitSwitcherButton.trailingAnchor.constraint(lessThanOrEqualTo: timerLabel.leadingAnchor, constant: -12),
                suitSwitcherButton.heightAnchor.constraint(equalToConstant: VibrantConstants.Measurements.buttonHeight * 0.8)
            ]
            NSLayoutConstraint.activate(suitSwitcherConstraints)
        }
    }
}

