//
//  GameVoyage+Variant.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/6.
//

import UIKit

extension GameVoyage {
    
    func configureVariantState() {
        objectiveSequences = variant.objectiveSequences
        rewindCrates.removeAll()
        preMoveCrate = nil
        elapsedSeconds = 0
        achievedScore = 0
        remainingSeconds = variant.timerDisposition.style == .countDown ? variant.timerDisposition.span : 0
        remainingMoves = variant.moveAllowance ?? 0
        rewindTokensRemaining = variant.rewindAllowance
        moveQuotaLabel.isHidden = true
        moveQuotaLabel.text = ""
        variantBadgeLabel.text = ""
        variantBadgeLabel.isHidden = true
        isHintVisible = false
        if variant.usesSuitCycler {
            if activeSuitIndex >= availableCategories.count {
                activeSuitIndex = 0
            }
            suitSwitcherButton.isHidden = false
            updateSuitSwitcherTitle()
        } else {
            suitSwitcherButton.isHidden = true
        }
        hintButton.isEnabled = true
        hintButton.alpha = 1.0
        configureObjectiveBoard()
    }
    
    func updateMoveQuotaLabel() {
        if variant.usesGridLayout {
            moveQuotaLabel.text = ""
            return
        }
        guard let allowance = variant.moveAllowance else {
            moveQuotaLabel.text = ""
            return
        }
        let suffix = remainingMoves == 1 ? "move" : "moves"
        moveQuotaLabel.text = "\(variant.moveLabelTitle): \(remainingMoves)/\(allowance) \(suffix)"
    }
    
    func updateRewindButtonState() {
        if variant.usesGridLayout {
            rewindButton.isEnabled = false
            rewindButton.alpha = 0.0
            rewindButton.isHidden = true
            return
        }
        guard variant.rewindAllowance > 0 else {
            rewindButton.isEnabled = false
            rewindButton.alpha = 0.4
            return
        }
        let canRewind = rewindTokensRemaining > 0 && !rewindCrates.isEmpty
        rewindButton.isEnabled = canRewind
        rewindButton.alpha = canRewind ? 1.0 : 0.4
    }
    
    func currentArrangementSnapshot() -> [[Int]] {
        return tileRowsVessels.map { row in
            row.map { $0.element.magnitude }
        }
    }
    
    func capturePreMoveCrate() {
        guard variant.moveAllowance != nil else { return }
        let snapshot = currentArrangementSnapshot()
        preMoveCrate = RewindCrate(vesselArrangement: snapshot, movesRemaining: remainingMoves)
    }
    
    func processCompletedMove() {
        guard variant.moveAllowance != nil, let storedCrate = preMoveCrate else { return }
        let latestSnapshot = currentArrangementSnapshot()
        if latestSnapshot != storedCrate.vesselArrangement {
            if variant.rewindAllowance > 0 {
                rewindCrates.append(storedCrate)
                if rewindCrates.count > variant.rewindAllowance {
                    rewindCrates.removeFirst(rewindCrates.count - variant.rewindAllowance)
                }
            }
            remainingMoves = max(0, remainingMoves - 1)
            updateMoveQuotaLabel()
            updateRewindButtonState()
            if remainingMoves == 0 {
                presentMoveLimitPrompt()
            }
        }
        preMoveCrate = nil
    }
    
    func presentMoveLimitPrompt() {
        guard variant.moveAllowance != nil else { return }
        let message: String
        if variant.rewindAllowance > 0 && !variant.usesGridLayout {
            message = "You have used every move. Confirm your arrangement or use Rewind if available."
        } else {
            message = "You have used every move. Confirm your arrangement to continue."
        }
        let alert = UIAlertController(
            title: "No Moves Remaining",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func applyRewindCrate(_ crate: RewindCrate) {
        for (index, magnitudes) in crate.vesselArrangement.enumerated() {
            guard index < tileRowsVessels.count, index < rowContainers.count else { continue }
            let existingRow = tileRowsVessels[index]
            let dictionary = Dictionary(uniqueKeysWithValues: existingRow.map { ($0.element.magnitude, $0) })
            let reordered = magnitudes.compactMap { dictionary[$0] }
            tileRowsVessels[index] = reordered
            if variant.usesGridLayout {
                layoutGridRow(reordered, in: rowContainers[index])
            } else {
                layoutTileColumn(reordered, in: rowContainers[index])
            }
        }
        remainingMoves = crate.movesRemaining
        updateMoveQuotaLabel()
    }
    
    func handleCountdownExpiration() {
        chronometer?.invalidate()
        achievedScore = 0
        displayIncompleteAlert(correctColumns: 0, total: tileRowsVessels.count, willAutoRestart: true, reason: "Time expired.")
    }
    
    func updateSuitSwitcherTitle() {
        guard variant.usesSuitCycler else { return }
        let title: String
        switch activeCategory {
        case .circles:
            title = "Suit: Circles"
        case .bamboo:
            title = "Suit: Bamboo"
        case .characters:
            title = "Suit: Characters"
        }
        suitSwitcherButton.setTitle(title, for: .normal)
        suitSwitcherButton.accessibilityLabel = title
    }
    
    func captureGridSnapshot() {
        guard variant.usesGridLayout, let vessels = tileRowsVessels.first else { return }
        let ordering = vessels.map { $0.element.magnitude }
        rewindCrates.removeAll()
        rewindTokensRemaining = variant.rewindAllowance
        let crate = RewindCrate(vesselArrangement: [ordering], movesRemaining: remainingMoves)
        rewindCrates.append(crate)
    }
}

