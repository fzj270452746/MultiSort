//
//  GameVoyage+Actions.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension GameVoyage {
    
    @objc func retreatTapped() {
        retreatButton.animateBounce()
        
        chronometer?.invalidate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func confirmTapped() {
        confirmButton.animateBounce()
        
        revealAllMagnitudes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.evaluateArrangement()
        }
    }
    
    @objc func shuffleTapped() {
        guard variant.allowsShuffle else { return }
        shuffleButton.animateBounce()
        resetColumnFeedback()
        shuffleAllRows()
    }
    
    @objc func rewindTapped() {
        guard variant.rewindAllowance > 0 else { return }
        guard rewindTokensRemaining > 0 else {
            let alert = UIAlertController(
                title: "No Rewinds Left",
                message: "You have already used the available rewind for this round.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        guard let crate = rewindCrates.popLast() else {
            let alert = UIAlertController(
                title: "Nothing to Rewind",
                message: "You need to make a move before using rewind.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        rewindButton.animateBounce()
        applyRewindCrate(crate)
        rewindTokensRemaining -= 1
        updateRewindButtonState()
        resetColumnFeedback()
    }
    
    @objc func yieldTapped() {
        yieldButton.animateBounce()
        chronometer?.invalidate()
        let alert = UIAlertController(
            title: "Give Up?",
            message: "Do you want to abandon this round and reshuffle?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.resumeChronometerAfterPause()
        }))
        alert.addAction(UIAlertAction(title: "Give Up", style: .destructive, handler: { [weak self] _ in
            self?.resetGame()
        }))
        present(alert, animated: true)
    }
    
    @objc func suitSwitcherTapped() {
        guard variant.usesSuitCycler else { return }
        suitSwitcherButton.animateBounce()
        activeSuitIndex = (activeSuitIndex + 1) % max(availableCategories.count, 1)
        updateSuitSwitcherTitle()
        resetGame()
    }
    
    func evaluateArrangement() {
        var isPerfect = true
        var correctColumns = 0
        
        // 检查每一列并给出视觉反馈
        for (index, row) in tileRowsVessels.enumerated() {
            let magnitudes = row.map { $0.element.magnitude }
            let expectedSequence: [Int]?
            if index < objectiveSequences.count {
                expectedSequence = objectiveSequences[index]
            } else {
                expectedSequence = nil
            }
            let isCorrect: Bool
            if let expected = expectedSequence, !expected.isEmpty {
                isCorrect = magnitudes == expected
            } else {
                let sortedMagnitudes = magnitudes.sorted()
                isCorrect = magnitudes == sortedMagnitudes
            }
            
            if isCorrect {
                correctColumns += 1
                showColumnFeedback(at: index, isCorrect: true)
            } else {
                isPerfect = false
                showColumnFeedback(at: index, isCorrect: false)
            }
        }
        
        chronometer?.invalidate()
        
        let movesUsed: Int?
        if let allowance = variant.moveAllowance {
            movesUsed = allowance - remainingMoves
        } else {
            movesUsed = nil
        }
        let timeLeft = variant.timerDisposition.style == .countDown ? remainingSeconds : 0
        let totalTime = variant.timerDisposition.span
        
        // 延迟显示结果，让用户看到每列的反馈
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            self.achievedScore = self.calculateScore(isPerfect: isPerfect, movesUsed: movesUsed, timeLeft: timeLeft, totalTime: totalTime)
            self.preserveGameMemorable(isPerfect: isPerfect, movesUsed: movesUsed, timeLeft: timeLeft, totalTime: totalTime)
            self.updateScoreDisplay()
            
            if isPerfect {
                self.displayVictoryAlert(willAutoRestart: true)
            } else {
                self.displayIncompleteAlert(correctColumns: correctColumns, total: self.tileRowsVessels.count, willAutoRestart: true, reason: nil)
            }
        }
    }
    
    func showColumnFeedback(at columnIndex: Int, isCorrect: Bool) {
        guard columnIndex < rowContainers.count else { return }
        let container = rowContainers[columnIndex]
        
        // 设置边框颜色和背景色
        let feedbackColor: UIColor
        let backgroundColor: UIColor
        
        if isCorrect {
            feedbackColor = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0) // 绿色
            backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 0.2)
        } else {
            feedbackColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0) // 红色
            backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.2)
        }
        
        // 添加动画效果
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                container.layer.borderColor = feedbackColor.cgColor
                container.layer.borderWidth = 4
                container.backgroundColor = backgroundColor
            }
        )
        
        // 添加对号或错号图标
        let iconView = createFeedbackIcon(isCorrect: isCorrect)
        iconView.center = CGPoint(x: container.bounds.width / 2, y: -30)
        iconView.alpha = 0
        container.addSubview(iconView)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                iconView.alpha = 1.0
                iconView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        )
    }
    
    func createFeedbackIcon(isCorrect: Bool) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        containerView.backgroundColor = isCorrect ? 
            UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0) :
            UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 4
        
        let iconImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let iconName = isCorrect ? "checkmark" : "xmark"
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(iconImageView)
        return containerView
    }
    
    func calculateScore(isPerfect: Bool, movesUsed: Int?, timeLeft: Int, totalTime: Int) -> Int {
        switch variant {
        case .classicFlow:
            let baseScore = 1000
            let timeBonus = max(0, 300 - elapsedSeconds) * 10
            let perfectBonus = isPerfect ? 500 : 0
            return baseScore + timeBonus + perfectBonus
        case .mindfulShuffle:
            let baseScore = 1500
            let remainingBonus = max(0, (variant.moveAllowance ?? 0) - (movesUsed ?? 0)) * 60
            let timeBonus = max(0, timeLeft) * 40
            let perfectBonus = isPerfect ? 800 : 0
            return baseScore + remainingBonus + timeBonus + perfectBonus
        }
    }
    
    func displayVictoryAlert(willAutoRestart: Bool) {
        let timeDescriptor: String
        var extraCountdownDetail = ""
        switch variant.timerDisposition.style {
        case .countUp:
            timeDescriptor = "\(VibrantConstants.Text.timer): \(formatElapsedTime(elapsedSeconds))"
        case .countDown:
            timeDescriptor = "Time Used: \(formatElapsedTime(elapsedSeconds))"
            extraCountdownDetail = "\nTime Left: \(formatElapsedTime(remainingSeconds))"
        }
        var message = "\(VibrantConstants.Text.perfectSort)\n\n\(VibrantConstants.Text.score): \(achievedScore)\n\(timeDescriptor)\(extraCountdownDetail)"
        if let allowance = variant.moveAllowance {
            let used = allowance - remainingMoves
            message += "\nMoves Used: \(used)/\(allowance)"
        }
        message += "\n\n" + (willAutoRestart ? "Starting new round..." : "")
        
        let alert = UIAlertController(
            title: VibrantConstants.Text.gameComplete,
            message: message,
            preferredStyle: .alert
        )
        
        present(alert, animated: true)
        
        if willAutoRestart {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                alert.dismiss(animated: true) {
                    self?.resetGame()
                }
            }
        }
    }
    
    func displayIncompleteAlert(correctColumns: Int, total: Int, willAutoRestart: Bool, reason: String?) {
        let timeDescriptor: String
        var extraCountdownDetail = ""
        switch variant.timerDisposition.style {
        case .countUp:
            timeDescriptor = "\(VibrantConstants.Text.timer): \(formatElapsedTime(elapsedSeconds))"
        case .countDown:
            timeDescriptor = "Time Used: \(formatElapsedTime(elapsedSeconds))"
            extraCountdownDetail = "\nTime Left: \(formatElapsedTime(remainingSeconds))"
        }
        var message = "You got \(correctColumns) out of \(total) sets correct!\n\n\(VibrantConstants.Text.score): \(achievedScore)\n\(timeDescriptor)\(extraCountdownDetail)"
        if let allowance = variant.moveAllowance {
            let used = allowance - remainingMoves
            message += "\nMoves Used: \(used)/\(allowance)"
        }
        if let reason = reason {
            message += "\n\n\(reason)"
        }
        message += "\n\n" + (willAutoRestart ? "Starting new round..." : "")
        
        let alert = UIAlertController(
            title: VibrantConstants.Text.tryAgain,
            message: message,
            preferredStyle: .alert
        )
        
        present(alert, animated: true)
        
        if willAutoRestart {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                alert.dismiss(animated: true) {
                    self?.resetGame()
                }
            }
        }
    }
    
    func resetColumnFeedback() {
        for container in rowContainers {
            // 移除反馈图标
            for subview in container.subviews {
                if subview.frame.origin.y < 0 {
                    subview.removeFromSuperview()
                }
            }
            
            // 恢复原始样式
            UIView.animate(withDuration: 0.3) {
                container.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
                container.layer.borderWidth = 2
                container.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            }
        }
    }
    
    func resetGame() {
        chronometer?.invalidate()
        configureVariantState()
        initializeTileRows()
        resetColumnFeedback()
        if variant.usesGridLayout, let crate = rewindCrates.last {
            applyRewindCrate(crate)
        } else {
            shuffleAllRows()
        }
        hasRevealed = false
        updateTimerDisplay()
        updateScoreDisplay()
        updateMoveQuotaLabel()
        updateRewindButtonState()
        updateSuitSwitcherTitle()
        commenceChronometer()
    }
    
    func preserveGameMemorable(isPerfect: Bool, movesUsed: Int?, timeLeft: Int, totalTime: Int) {
        let recordedElapsed: Int
        switch variant.timerDisposition.style {
        case .countUp:
            recordedElapsed = elapsedSeconds
        case .countDown:
            recordedElapsed = totalTime - timeLeft
        }
        let rememberedMoves = movesUsed ?? variant.moveAllowance.map { $0 - remainingMoves }
        let timeReserve = variant.timerDisposition.style == .countDown ? timeLeft : nil
        let memorable = GameMemorable(
            timestamp: Date(),
            elapsedSeconds: recordedElapsed,
            achievedScore: achievedScore,
            wasPerfect: isPerfect,
            variantIdentifier: variant.identifier,
            moveFootprint: rememberedMoves,
            residualTime: timeReserve,
            usedRewind: rewindTokensRemaining < variant.rewindAllowance
        )
        ScoreArchive.singleton.preserveMemorable(memorable)
    }
}

