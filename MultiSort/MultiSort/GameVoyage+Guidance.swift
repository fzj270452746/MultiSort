//
//  GameVoyage+Guidance.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/5.
//

import UIKit

extension GameVoyage {
    
    func displayDragGuidance() {
        if variant.usesGridLayout {
            guard let grid = tileRowsVessels.first, !grid.isEmpty else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.displayGridTapGuidance(for: grid)
            }
        } else {
            guard tileRowsVessels.count == 3 else { return }
            // 为第一列添加点击交换引导动画
            if let firstColumn = tileRowsVessels.first, firstColumn.count >= 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                    self?.displayColumnTapGuidance(for: firstColumn)
                }
            }
        }
    }
    
    func displayColumnTapGuidance(for column: [TileVessel]) {
        guard column.count >= 2 else { return }
        
        // 选择两个位置相邻的麻将进行演示，让效果更明显
        let sortedVessels = column.sorted { $0.frame.origin.y < $1.frame.origin.y }
        guard sortedVessels.count >= 2 else { return }
        
        // 选择第一个和第二个相邻的麻将
        let firstVessel = sortedVessels[0]
        let secondVessel = sortedVessels[1]
        
        guard let container = firstVessel.superview else { return }
        
        // 创建说明文字，添加到主视图而非容器中，确保不被遮挡
        let instructionLabel = createInstructionLabel(text: "Tap two tiles to swap")
        view.addSubview(instructionLabel)
        view.bringSubviewToFront(instructionLabel)
        instructionLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        instructionLabel.alpha = 0
        
        // 创建两个手指点击图标
        let handImageView1 = createTapIndicator()
        let handImageView2 = createTapIndicator()
        container.addSubview(handImageView1)
        container.addSubview(handImageView2)
        
        handImageView1.center = CGPoint(x: firstVessel.frame.midX, y: firstVessel.frame.midY)
        handImageView2.center = CGPoint(x: secondVessel.frame.midX, y: secondVessel.frame.midY)
        
        // 执行点击交换动画序列
        UIView.animateKeyframes(
            withDuration: 5.0,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                // 0-10%: 显示说明文字
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.10) {
                    instructionLabel.alpha = 1.0
                }
                
                // 10-20%: 第一次点击
                UIView.addKeyframe(withRelativeStartTime: 0.10, relativeDuration: 0.10) {
                    handImageView1.alpha = 1.0
                    handImageView1.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    firstVessel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    firstVessel.layer.borderWidth = 4
                    firstVessel.layer.borderColor = UIColor.yellow.cgColor
                    firstVessel.layer.shadowColor = UIColor.yellow.cgColor
                    firstVessel.layer.shadowOpacity = 0.8
                    firstVessel.layer.shadowRadius = 12
                }
                
                // 20-25%: 第一个手指恢复，保持选中状态
                UIView.addKeyframe(withRelativeStartTime: 0.20, relativeDuration: 0.05) {
                    handImageView1.transform = .identity
                    handImageView1.alpha = 0.4
                }
                
                // 25-30%: 停顿，显示选中状态
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.05) {
                    // 保持第一个麻将的选中状态
                }
                
                // 30-40%: 第二次点击
                UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.10) {
                    handImageView2.alpha = 1.0
                    handImageView2.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    secondVessel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }
                
                // 40-60%: 交换位置动画
                UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.20) {
                    let firstCenter = firstVessel.center
                    let secondCenter = secondVessel.center
                    firstVessel.center = secondCenter
                    secondVessel.center = firstCenter
                    handImageView1.center = secondCenter
                    handImageView2.center = firstCenter
                }
                
                // 60-70%: 恢复状态
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.10) {
                    firstVessel.transform = .identity
                    secondVessel.transform = .identity
                    firstVessel.layer.borderWidth = 0
                    firstVessel.layer.shadowOpacity = 0.15
                    firstVessel.layer.shadowRadius = 4
                    handImageView1.alpha = 0
                    handImageView2.alpha = 0
                }
                
                // 70-100%: 淡出说明文字，保持交换后的位置
                UIView.addKeyframe(withRelativeStartTime: 0.70, relativeDuration: 0.30) {
                    instructionLabel.alpha = 0
                }
            },
            completion: { [weak self] _ in
                handImageView1.removeFromSuperview()
                handImageView2.removeFromSuperview()
                instructionLabel.removeFromSuperview()
                // 恢复原始顺序
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.rearrangeRow(0)
                }
            }
        )
        
        // 添加脉动效果
        addPulseAnimation(to: firstVessel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.addPulseAnimation(to: secondVessel)
        }
    }
    
    func displayGridTapGuidance(for vessels: [TileVessel]) {
        guard vessels.count >= 2 else { return }
        guard let minVessel = vessels.min(by: { $0.element.magnitude < $1.element.magnitude }),
              let maxVessel = vessels.max(by: { $0.element.magnitude < $1.element.magnitude }),
              let container = minVessel.superview else { return }
        
        // 创建说明文字，添加到主视图中心
        let instructionLabel = createInstructionLabel(text: "Tap two tiles to swap")
        view.addSubview(instructionLabel)
        view.bringSubviewToFront(instructionLabel)
        instructionLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        instructionLabel.alpha = 0
        
        // 创建两个手指点击图标
        let handImageView1 = createTapIndicator()
        let handImageView2 = createTapIndicator()
        container.addSubview(handImageView1)
        container.addSubview(handImageView2)
        
        handImageView1.center = CGPoint(x: minVessel.frame.midX, y: minVessel.frame.midY)
        handImageView2.center = CGPoint(x: maxVessel.frame.midX, y: maxVessel.frame.midY)
        
        // 执行点击交换动画序列
        UIView.animateKeyframes(
            withDuration: 5.0,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                // 0-10%: 显示说明文字
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.10) {
                    instructionLabel.alpha = 1.0
                }
                
                // 10-20%: 第一次点击
                UIView.addKeyframe(withRelativeStartTime: 0.10, relativeDuration: 0.10) {
                    handImageView1.alpha = 1.0
                    handImageView1.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    minVessel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    minVessel.layer.borderWidth = 4
                    minVessel.layer.borderColor = UIColor.yellow.cgColor
                    minVessel.layer.shadowColor = UIColor.yellow.cgColor
                    minVessel.layer.shadowOpacity = 0.8
                    minVessel.layer.shadowRadius = 12
                }
                
                // 20-25%: 第一个手指恢复，保持选中状态
                UIView.addKeyframe(withRelativeStartTime: 0.20, relativeDuration: 0.05) {
                    handImageView1.transform = .identity
                    handImageView1.alpha = 0.4
                }
                
                // 30-40%: 第二次点击
                UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.10) {
                    handImageView2.alpha = 1.0
                    handImageView2.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    maxVessel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }
                
                // 40-60%: 交换位置
                UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.20) {
                    let minCenter = minVessel.center
                    let maxCenter = maxVessel.center
                    minVessel.center = maxCenter
                    maxVessel.center = minCenter
                    handImageView1.center = maxCenter
                    handImageView2.center = minCenter
                }
                
                // 60-70%: 恢复状态
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.10) {
                    minVessel.transform = .identity
                    maxVessel.transform = .identity
                    minVessel.layer.borderWidth = 0
                    minVessel.layer.shadowOpacity = 0.15
                    minVessel.layer.shadowRadius = 4
                    handImageView1.alpha = 0
                    handImageView2.alpha = 0
                }
                
                // 70-100%: 淡出说明文字
                UIView.addKeyframe(withRelativeStartTime: 0.70, relativeDuration: 0.30) {
                    instructionLabel.alpha = 0
                }
            },
            completion: { [weak self] _ in
                handImageView1.removeFromSuperview()
                handImageView2.removeFromSuperview()
                instructionLabel.removeFromSuperview()
                // 恢复原始位置
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let container = container as? UIView, let vessels = self?.tileRowsVessels.first {
                        self?.layoutGridRow(vessels, in: container)
                    }
                }
            }
        )
        
        addPulseAnimation(to: minVessel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.addPulseAnimation(to: maxVessel)
        }
    }
    
    func createTapIndicator() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        containerView.backgroundColor = .clear
        containerView.alpha = 0
        
        // 创建背景圆圈
        let circleView = UIView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        circleView.backgroundColor = VibrantConstants.Palette.primaryTint.withAlphaComponent(0.3)
        circleView.layer.cornerRadius = 25
        circleView.layer.borderWidth = 3
        circleView.layer.borderColor = VibrantConstants.Palette.primaryTint.cgColor
        containerView.addSubview(circleView)
        
        // 创建点击图标（手指点击）
        let imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 40, height: 40))
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold)
        imageView.image = UIImage(systemName: "hand.tap.fill", withConfiguration: config)
        imageView.tintColor = VibrantConstants.Palette.primaryTint
        imageView.contentMode = .scaleAspectFit
        
        // 添加发光效果
        circleView.layer.shadowColor = VibrantConstants.Palette.primaryTint.cgColor
        circleView.layer.shadowOffset = .zero
        circleView.layer.shadowOpacity = 1.0
        circleView.layer.shadowRadius = 10
        
        containerView.addSubview(imageView)
        return containerView
    }
    
    func createInstructionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = VibrantConstants.Palette.primaryTint.withAlphaComponent(0.95)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = false
        label.numberOfLines = 1
        
        // 设置内边距
        let padding = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        label.frame.size = CGSize(
            width: text.size(withAttributes: [.font: label.font!]).width + padding.left + padding.right,
            height: 48
        )
        
        // 添加更明显的阴影，确保在任何背景下都清晰可见
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 12
        
        // 添加边框增强可见性
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        
        return label
    }
    
    func addPulseAnimation(to vessel: TileVessel) {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 0.6
        pulseAnimation.duration = 0.5
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 6
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        vessel.layer.add(pulseAnimation, forKey: "pulseAnimation")
    }
}

