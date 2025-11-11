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
                self?.displayGridGuidance(for: grid)
            }
        } else {
            guard tileRowsVessels.count == 3 else { return }
            // 为每一列添加引导动画，延迟依次播放
            for (columnIndex, column) in tileRowsVessels.enumerated() {
                guard column.count >= 2 else { continue }
                
                let delay = Double(columnIndex) * 0.8 // 每列间隔0.8秒
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    self?.displayColumnGuidance(for: column, at: columnIndex)
                }
            }
        }
    }
    
    func displayColumnGuidance(for column: [TileVessel], at columnIndex: Int) {
        guard !column.isEmpty else { return }
        
        // 找到该列中magnitude最小的麻将（数值为1的麻将）
        guard let minVessel = column.min(by: { $0.element.magnitude < $1.element.magnitude }) else { return }
        
        let demoVessel = minVessel
        let originalFrame = demoVessel.frame
        
        let movementAxis = variant.movementAxis
        let targetPosition = CGFloat(0)
        
        // 创建手指图标提示
        let handImageView = createHandIndicator(for: movementAxis)
        demoVessel.superview?.addSubview(handImageView)
        
        // 手指图标位置在麻将中心
        handImageView.center = CGPoint(
            x: demoVessel.frame.midX,
            y: demoVessel.frame.midY
        )
        
        // 执行动画序列
        UIView.animateKeyframes(
            withDuration: 3.0,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                // 0-15%: 放大麻将和手指，吸引注意
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                    demoVessel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    handImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    handImageView.alpha = 1.0
                }
                
                // 15-45%: 移动到目标位置（演示正确的排序位置）
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3) {
                    switch movementAxis {
                    case .vertical:
                        demoVessel.frame.origin.y = targetPosition
                        handImageView.center.y = demoVessel.frame.midY
                    case .horizontal:
                        demoVessel.frame.origin.x = targetPosition
                        handImageView.center.x = demoVessel.frame.midX
                    @unknown default:
                        break
                    }
                }
                
                // 45-55%: 停顿，让用户看清楚最小的麻将应该在顶部
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.15) {
                    // 保持在顶部位置
                }
                
                // 60-85%: 移动回到原位
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.25) {
                    demoVessel.frame = originalFrame
                    handImageView.center = CGPoint(x: demoVessel.frame.midX, y: demoVessel.frame.midY)
                }
                
                // 85-100%: 恢复原状并淡出
                UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                    demoVessel.frame = originalFrame
                    demoVessel.transform = .identity
                    handImageView.alpha = 0
                    handImageView.center = CGPoint(
                        x: demoVessel.frame.midX,
                        y: demoVessel.frame.midY
                    )
                }
            },
            completion: { _ in
                handImageView.removeFromSuperview()
            }
        )
        
        // 添加脉动效果让演示更明显
        addPulseAnimation(to: demoVessel)
    }
    
    func displayGridGuidance(for vessels: [TileVessel]) {
        guard let demoVessel = vessels.min(by: { $0.element.magnitude < $1.element.magnitude }),
              let container = demoVessel.superview else { return }
        let originalFrame = demoVessel.frame
        let targetOrigin = CGPoint(x: 0, y: 0)
        let handImageView = createHandIndicator(for: .horizontal)
        container.addSubview(handImageView)
        handImageView.center = CGPoint(x: demoVessel.frame.midX, y: demoVessel.frame.midY)
        
        UIView.animateKeyframes(
            withDuration: 3.0,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                    demoVessel.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    handImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    handImageView.alpha = 1.0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3) {
                    demoVessel.frame.origin = targetOrigin
                    handImageView.center = CGPoint(x: demoVessel.frame.midX, y: demoVessel.frame.midY)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.15) {}
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.25) {
                    demoVessel.frame = originalFrame
                    handImageView.center = CGPoint(x: demoVessel.frame.midX, y: demoVessel.frame.midY)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                    demoVessel.frame = originalFrame
                    demoVessel.transform = .identity
                    handImageView.alpha = 0
                }
            }, completion: { _ in
                handImageView.removeFromSuperview()
            })
        addPulseAnimation(to: demoVessel)
    }
    
    func createHandIndicator(for axis: NSLayoutConstraint.Axis) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        containerView.backgroundColor = .clear
        containerView.alpha = 0
        
        // 创建一个手指图标（使用系统图标）
        let imageView = UIImageView(frame: containerView.bounds)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        let symbolName: String = {
            switch axis {
            case .horizontal:
                return "hand.point.left.fill"
            default:
                return "hand.point.up.fill"
            }
        }()
        imageView.image = UIImage(systemName: symbolName, withConfiguration: config)
        imageView.tintColor = VibrantConstants.Palette.primaryTint
        imageView.contentMode = .scaleAspectFit
        
        // 添加阴影增强视觉效果
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 4
        
        containerView.addSubview(imageView)
        return containerView
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

