//
//  WelcomeVoyage+Actions.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension WelcomeVoyage {
    
    @objc func startGameTapped() {
        startButton.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            let selector = ModeSelectionController()
            selector.modalPresentationStyle = .overFullScreen
            selector.modalTransitionStyle = .crossDissolve
            selector.onSelect = { [weak self] variant in
                self?.launchGame(with: variant)
            }
            selector.onCancel = { [weak self] in
                self?.startButton.animateBounce()
            }
            self.present(selector, animated: false)
        }
    }
    
    @objc func instructionsTapped() {
        instructionsButton.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let instructionsVoyage = InstructionsVoyage()
            self?.navigationController?.pushViewController(instructionsVoyage, animated: true)
        }
    }
    
    @objc func recordsTapped() {
        recordsButton.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let recordsVoyage = RecordsVoyage()
            self?.navigationController?.pushViewController(recordsVoyage, animated: true)
        }
    }
    
    func animateEntrance() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        
        containerStack.alpha = 0
        containerStack.transform = CGAffineTransform(translationX: 0, y: 50)
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.1,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.titleLabel.alpha = 1
                self.titleLabel.transform = .identity
            }
        )
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.3,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.containerStack.alpha = 1
                self.containerStack.transform = .identity
            }
        )
    }
    
    func launchGame(with variant: GameVariant) {
        let gameVoyage = GameVoyage(variant: variant)
        navigationController?.pushViewController(gameVoyage, animated: true)
    }
}

