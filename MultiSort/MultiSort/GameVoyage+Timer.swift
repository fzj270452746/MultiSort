//
//  GameVoyage+Timer.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension GameVoyage {
    
    func commenceChronometer() {
        chronometer?.invalidate()
        elapsedSeconds = 0
        switch variant.timerDisposition.style {
        case .countUp:
            break
        case .countDown:
            remainingSeconds = variant.timerDisposition.span
        }
        updateTimerDisplay()
        scheduleChronometer()
    }
    
    func updateTimerDisplay() {
        switch variant.timerDisposition.style {
        case .countUp:
            timerLabel.text = "\(VibrantConstants.Text.timer): \(formatElapsedTime(elapsedSeconds))"
        case .countDown:
            timerLabel.text = "Time Left: \(formatElapsedTime(remainingSeconds))"
        }
    }
    
    func updateScoreDisplay() {
        scoreLabel.text = "\(VibrantConstants.Text.score): \(achievedScore)"
    }
    
    func formatElapsedTime(_ secondsValue: Int) -> String {
        let minutes = secondsValue / 60
        let seconds = secondsValue % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func scheduleChronometer() {
        chronometer?.invalidate()
        switch variant.timerDisposition.style {
        case .countUp:
            chronometer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds += 1
                self.updateTimerDisplay()
            }
        case .countDown:
            guard remainingSeconds > 0 else { return }
            chronometer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.remainingSeconds = max(0, self.remainingSeconds - 1)
                let total = self.variant.timerDisposition.span
                self.elapsedSeconds = total - self.remainingSeconds
                self.updateTimerDisplay()
                if self.remainingSeconds == 0 {
                    self.chronometer?.invalidate()
                    self.handleCountdownExpiration()
                }
            }
        }
    }
    
    func resumeChronometerAfterPause() {
        scheduleChronometer()
    }
}

