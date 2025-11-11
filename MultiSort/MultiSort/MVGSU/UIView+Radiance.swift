//
//  UIView+Radiance.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension UIView {
    
    func applyRadiantShadow() {
        layer.shadowColor = VibrantConstants.Palette.deepShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
    
    func applySubtleShadow() {
        layer.shadowColor = VibrantConstants.Palette.deepShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func animateBounce() {
        UIView.animate(
            withDuration: VibrantConstants.Motion.bounceDuration,
            delay: 0,
            usingSpringWithDamping: VibrantConstants.Motion.springDamping,
            initialSpringVelocity: VibrantConstants.Motion.springVelocity,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            },
            completion: { _ in
                UIView.animate(withDuration: VibrantConstants.Motion.standardDuration) {
                    self.transform = .identity
                }
            }
        )
    }
    
    func animatePulse() {
        UIView.animate(
            withDuration: VibrantConstants.Motion.standardDuration,
            animations: {
                self.alpha = 0.6
            },
            completion: { _ in
                UIView.animate(withDuration: VibrantConstants.Motion.standardDuration) {
                    self.alpha = 1.0
                }
            }
        )
    }
    
    func animateShake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
}

