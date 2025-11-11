//
//  GameVoyage+Gestures.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension GameVoyage {
    
    // MARK: - Tap Gesture (New Click-to-Swap Interaction)
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let vessel = gesture.view as? TileVessel else { return }
        
        // 找到该麻将的行索引和位置索引
        var rowIndex = -1
        var positionIndex = -1
        
        for (rIndex, row) in tileRowsVessels.enumerated() {
            if let pIndex = row.firstIndex(where: { $0 === vessel }) {
                rowIndex = rIndex
                positionIndex = pIndex
                break
            }
        }
        
        guard rowIndex >= 0 && positionIndex >= 0 else { return }
        
        // 使用交互管理器处理点击
        interactionManager.handleTap(on: vessel, in: rowIndex, at: positionIndex)
    }
}

// MARK: - TileInteractionDelegate
extension GameVoyage: TileInteractionDelegate {
    
    func canPerformMove() -> Bool {
        if let allowance = variant.moveAllowance, allowance > 0 {
            return remainingMoves > 0
        }
        return true
    }
    
    func canSwapTiles(from: (row: Int, position: Int), to: (row: Int, position: Int)) -> Bool {
        // Classic Flow模式：只能在同一列内交换
        if !variant.usesGridLayout {
            return from.row == to.row
        }
        // Grid布局：可以在网格内任意交换
        return true
    }
    
    func tilesSwapped(from: (row: Int, position: Int), to: (row: Int, position: Int)) {
        // 交换数据模型中的位置
        let rowIndex = from.row
        guard rowIndex >= 0 && rowIndex < tileRowsVessels.count else { return }
        
        var vessels = tileRowsVessels[rowIndex]
        guard from.position < vessels.count && to.position < vessels.count else { return }
        
        // 交换
        vessels.swapAt(from.position, to.position)
        tileRowsVessels[rowIndex] = vessels
        
        // 重新布局
        if variant.usesGridLayout {
            if let container = rowContainers.first {
                layoutGridRow(vessels, in: container)
            }
        } else {
            rearrangeRow(rowIndex)
        }
    }
    
    func capturePreMoveState() {
        capturePreMoveCrate()
    }
    
    func moveCompleted() {
        processCompletedMove()
    }
    
    func showMoveLimitAlert() {
        presentMoveLimitPrompt()
    }
    
    func tileSelected(_ vessel: TileVessel) {
        // 可选：添加音效或其他反馈
    }
    
    func tileDeselected() {
        // 可选：添加音效或其他反馈
    }
}

