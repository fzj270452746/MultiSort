//
//  GameVoyage+Appearance.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension GameVoyage {
    
    func configureAppearance() {
        configureBackdrop()
        configureRetreatButton()
        configureLabels()
        configureObjectiveBoard()
        configureButtons()
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
    
    func configureLabels() {
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        timerLabel.textColor = VibrantConstants.Palette.pureWhite
        timerLabel.text = "\(VibrantConstants.Text.timer): 00:00"
        timerLabel.applySubtleShadow()
        
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        scoreLabel.textColor = VibrantConstants.Palette.pureWhite
        scoreLabel.text = "\(VibrantConstants.Text.score): 0"
        scoreLabel.applySubtleShadow()
        
        variantBadgeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        variantBadgeLabel.textColor = VibrantConstants.Palette.pureWhite
        variantBadgeLabel.numberOfLines = 2
        variantBadgeLabel.alpha = 0.9
        variantBadgeLabel.text = ""
        variantBadgeLabel.isHidden = true
        
        moveQuotaLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        moveQuotaLabel.textColor = VibrantConstants.Palette.pureWhite
        moveQuotaLabel.text = variant.usesGridLayout ? "" : variant.moveLabelTitle
        moveQuotaLabel.isHidden = variant.usesGridLayout || !variant.usesTopHintPlacement
    }
    
    func configureObjectiveBoard() {
        objectiveBoard.axis = .vertical
        objectiveBoard.alignment = .leading
        objectiveBoard.spacing = 6
        objectiveBoard.isHidden = variant.objectiveSequences.isEmpty || variant.usesGridLayout
        objectiveBoard.arrangedSubviews.forEach { view in
            objectiveBoard.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        objectiveLabels.removeAll()
        
        guard !variant.objectiveSequences.isEmpty, !variant.usesGridLayout else { return }
        do {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            titleLabel.textColor = VibrantConstants.Palette.pureWhite
            titleLabel.text = "Objective"
            objectiveBoard.addArrangedSubview(titleLabel)
            objectiveLabels.append(titleLabel)
            for (index, sequence) in variant.objectiveSequences.enumerated() {
                let label = UILabel()
                label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
                label.textColor = UIColor.white.withAlphaComponent(0.9)
                let sequenceString = sequence.map { String($0) }.joined(separator: " → ")
                label.text = "Column \(index + 1): \(sequenceString)"
                objectiveBoard.addArrangedSubview(label)
                objectiveLabels.append(label)
            }
        }
    }
    
    func configureButtons() {
        commandRibbon.axis = .horizontal
        commandRibbon.spacing = 12
        commandRibbon.distribution = .fillEqually
        
        let sharedButtons = [hintButton, confirmButton, shuffleButton, rewindButton, yieldButton, suitSwitcherButton]
        sharedButtons.forEach { button in
            button.layer.cornerRadius = VibrantConstants.Measurements.cornerRadius
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            button.setTitleColor(VibrantConstants.Palette.pureWhite, for: .normal)
            button.applyRadiantShadow()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: VibrantConstants.Measurements.buttonHeight).isActive = false
        }
        
        hintButton.setTitle("Hint", for: .normal)
        hintButton.backgroundColor = UIColor(red: 0.95, green: 0.55, blue: 0.25, alpha: 1.0)
        hintButton.addTarget(self, action: #selector(hintTapped(_:)), for: .touchUpInside)
        
        confirmButton.setTitle(VibrantConstants.Text.confirmOrder, for: .normal)
        confirmButton.backgroundColor = VibrantConstants.Palette.primaryTint
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        
        shuffleButton.setTitle(VibrantConstants.Text.shuffle, for: .normal)
        shuffleButton.backgroundColor = VibrantConstants.Palette.accentTint
        shuffleButton.addTarget(self, action: #selector(shuffleTapped), for: .touchUpInside)
        
        rewindButton.setTitle("Rewind", for: .normal)
        rewindButton.backgroundColor = UIColor(red: 0.36, green: 0.54, blue: 0.96, alpha: 1.0)
        rewindButton.addTarget(self, action: #selector(rewindTapped), for: .touchUpInside)
        
        yieldButton.setTitle("Give Up", for: .normal)
        yieldButton.backgroundColor = UIColor(red: 0.85, green: 0.33, blue: 0.24, alpha: 1.0)
        yieldButton.addTarget(self, action: #selector(yieldTapped), for: .touchUpInside)
        
        suitSwitcherButton.setTitle("Switch Suit", for: .normal)
        suitSwitcherButton.backgroundColor = UIColor(red: 0.30, green: 0.70, blue: 0.55, alpha: 1.0)
        suitSwitcherButton.addTarget(self, action: #selector(suitSwitcherTapped), for: .touchUpInside)
        suitSwitcherButton.isHidden = !variant.usesSuitCycler
        
        commandRibbon.arrangedSubviews.forEach { view in
            commandRibbon.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        if variant.usesTopHintPlacement {
            if variant.rewindAllowance > 0 && !variant.usesGridLayout {
                commandRibbon.addArrangedSubview(rewindButton)
            }
            commandRibbon.addArrangedSubview(confirmButton)
            commandRibbon.addArrangedSubview(yieldButton)
            hintButton.layer.cornerRadius = 18
            hintButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            hintButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        } else {
            commandRibbon.addArrangedSubview(hintButton)
            commandRibbon.addArrangedSubview(confirmButton)
            commandRibbon.addArrangedSubview(shuffleButton)
        }
        
        rewindButton.isHidden = !variant.usesTopHintPlacement || variant.usesGridLayout
        yieldButton.isHidden = !variant.usesTopHintPlacement
        shuffleButton.isHidden = variant.usesTopHintPlacement
        if variant.usesGridLayout {
            rewindButton.alpha = 0.0
            rewindButton.isEnabled = false
        }
    }
}

