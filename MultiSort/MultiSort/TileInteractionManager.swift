//
//  TileInteractionManager.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/11.
//

import UIKit

/// 麻将交互管理器 - 处理点击交换逻辑
class TileInteractionManager {
    
    weak var delegate: TileInteractionDelegate?
    
    private var firstSelectedVessel: TileVessel?
    private var firstRowIndex: Int = -1
    private var firstPositionIndex: Int = -1
    
    // MARK: - Tap Handling
    func handleTap(on vessel: TileVessel, in rowIndex: Int, at positionIndex: Int) {
        // 检查是否可以移动
        if delegate?.canPerformMove() == false {
            delegate?.showMoveLimitAlert()
            return
        }
        
        // 第一次选择
        if firstSelectedVessel == nil {
            selectFirstTile(vessel, rowIndex: rowIndex, positionIndex: positionIndex)
        } else if firstSelectedVessel === vessel {
            // 点击同一个麻将，取消选择
            deselectFirstTile()
        } else {
            // 第二次选择，执行交换
            swapTiles(vessel, rowIndex: rowIndex, positionIndex: positionIndex)
        }
    }
    
    // MARK: - Selection Management
    private func selectFirstTile(_ vessel: TileVessel, rowIndex: Int, positionIndex: Int) {
        firstSelectedVessel = vessel
        firstRowIndex = rowIndex
        firstPositionIndex = positionIndex
        
        // 高亮选中的麻将
        highlightVessel(vessel)
        delegate?.tileSelected(vessel)
    }
    
    private func deselectFirstTile() {
        guard let vessel = firstSelectedVessel else { return }
        unhighlightVessel(vessel)
        firstSelectedVessel = nil
        firstRowIndex = -1
        firstPositionIndex = -1
        delegate?.tileDeselected()
    }
    
    // MARK: - Swap Logic
    private func swapTiles(_ secondVessel: TileVessel, rowIndex: Int, positionIndex: Int) {
        guard let firstVessel = firstSelectedVessel else { return }
        
        // 捕获移动前的状态（用于撤销）
        delegate?.capturePreMoveState()
        
        // 执行交换
        let canSwap = delegate?.canSwapTiles(
            from: (firstRowIndex, firstPositionIndex),
            to: (rowIndex, positionIndex)
        ) ?? false
        
        if canSwap {
            performSwapAnimation(first: firstVessel, second: secondVessel) { [weak self] in
                self?.delegate?.tilesSwapped(
                    from: (self?.firstRowIndex ?? -1, self?.firstPositionIndex ?? -1),
                    to: (rowIndex, positionIndex)
                )
                
                // 取消选择状态
                self?.unhighlightVessel(firstVessel)
                self?.firstSelectedVessel = nil
                self?.firstRowIndex = -1
                self?.firstPositionIndex = -1
                
                // 处理移动完成
                self?.delegate?.moveCompleted()
            }
        } else {
            // 不允许交换（例如不在同一行/列），取消选择
            deselectFirstTile()
        }
    }
    
    // MARK: - Visual Feedback
    private func highlightVessel(_ vessel: TileVessel) {
        UIView.animate(withDuration: 0.2) {
            vessel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            vessel.layer.borderWidth = 3
            vessel.layer.borderColor = UIColor.yellow.cgColor
            vessel.layer.shadowColor = UIColor.yellow.cgColor
            vessel.layer.shadowOpacity = 0.6
            vessel.layer.shadowRadius = 10
            vessel.layer.shadowOffset = .zero
        }
    }
    
    private func unhighlightVessel(_ vessel: TileVessel) {
        UIView.animate(withDuration: 0.2) {
            vessel.transform = .identity
            vessel.layer.borderWidth = 0
            vessel.layer.shadowColor = VibrantConstants.Palette.deepShadow.cgColor
            vessel.layer.shadowOpacity = 0.15
            vessel.layer.shadowRadius = 4
            vessel.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    private func performSwapAnimation(first: TileVessel, second: TileVessel, completion: @escaping () -> Void) {
        let firstCenter = first.center
        let secondCenter = second.center
        
        UIView.animate(
            withDuration: VibrantConstants.Motion.standardDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                first.center = secondCenter
                second.center = firstCenter
            },
            completion: { _ in
                completion()
            }
        )
    }
    
    // MARK: - Reset
    func reset() {
        if let vessel = firstSelectedVessel {
            unhighlightVessel(vessel)
        }
        firstSelectedVessel = nil
        firstRowIndex = -1
        firstPositionIndex = -1
    }
}

/// 麻将交互代理协议
protocol TileInteractionDelegate: AnyObject {
    func canPerformMove() -> Bool
    func canSwapTiles(from: (row: Int, position: Int), to: (row: Int, position: Int)) -> Bool
    func tilesSwapped(from: (row: Int, position: Int), to: (row: Int, position: Int))
    func capturePreMoveState()
    func moveCompleted()
    func showMoveLimitAlert()
    func tileSelected(_ vessel: TileVessel)
    func tileDeselected()
}

