//
//  GameVoyage+Gestures.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension GameVoyage {
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let vessel = gesture.view as? TileVessel else { return }
        
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            if let allowance = variant.moveAllowance, allowance > 0 && remainingMoves == 0 {
                presentMoveLimitPrompt()
                gesture.isEnabled = false
                gesture.isEnabled = true
                return
            }
            draggedVessel = vessel
            dragInitialCenter = vessel.center
            
            for (rowIndex, row) in tileRowsVessels.enumerated() {
                if row.contains(where: { $0 === vessel }) {
                    draggedRowIndex = rowIndex
                    break
                }
            }
            
            capturePreMoveCrate()
            
            UIView.animate(withDuration: 0.2) {
                vessel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                vessel.alpha = 0.8
            }
            vessel.superview?.bringSubviewToFront(vessel)
            
        case .changed:
            if variant.usesGridLayout {
                vessel.center = CGPoint(
                    x: dragInitialCenter.x + translation.x,
                    y: dragInitialCenter.y + translation.y
                )
            } else {
                vessel.center = CGPoint(
                    x: dragInitialCenter.x,
                    y: dragInitialCenter.y + translation.y
                )
            }
            
            if !variant.usesGridLayout {
                detectSwapOpportunity(for: vessel, in: draggedRowIndex)
            }
            
        case .ended, .cancelled:
            UIView.animate(
                withDuration: VibrantConstants.Motion.standardDuration,
                animations: {
                    vessel.transform = .identity
                    vessel.alpha = 1.0
                }
            )
            
            if variant.usesGridLayout {
                finalizeGridPlacement(for: vessel)
            } else {
                rearrangeRow(draggedRowIndex)
            }
            processCompletedMove()
            draggedVessel = nil
            draggedRowIndex = -1
            
        default:
            break
        }
    }
    
    func detectSwapOpportunity(for vessel: TileVessel, in rowIndex: Int) {
        guard rowIndex >= 0 && rowIndex < tileRowsVessels.count else { return }
        guard !variant.usesGridLayout else { return }
        
        var vessels = tileRowsVessels[rowIndex]
        guard let currentIndex = vessels.firstIndex(where: { $0 === vessel }) else { return }
        
        for (index, otherVessel) in vessels.enumerated() {
            guard otherVessel !== vessel else { continue }
            
            if variant.usesGridLayout {
                let midX = vessel.frame.midX
                if midX > otherVessel.frame.minX && midX < otherVessel.frame.maxX {
                    vessels.remove(at: currentIndex)
                    vessels.insert(vessel, at: index)
                    tileRowsVessels[rowIndex] = vessels
                    break
                }
            } else {
                let midY = vessel.frame.midY
                if midY > otherVessel.frame.minY && midY < otherVessel.frame.maxY {
                    vessels.remove(at: currentIndex)
                    vessels.insert(vessel, at: index)
                    tileRowsVessels[rowIndex] = vessels
                    break
                }
            }
        }
    }
    
    func finalizeGridPlacement(for vessel: TileVessel) {
        guard variant.usesGridLayout,
              let container = rowContainers.first,
              var vessels = tileRowsVessels.first,
              let currentIndex = vessels.firstIndex(where: { $0 === vessel }) else { return }
        
        let localCenter = container.convert(vessel.center, from: vessel.superview)
        let columnCenters = (0..<layoutBlueprint.columns).map { layoutBlueprint.tileWidth / 2 + CGFloat($0) * (layoutBlueprint.tileWidth + layoutBlueprint.tileSpacing) }
        let rowCenters = (0..<layoutBlueprint.rows).map { layoutBlueprint.tileHeight / 2 + CGFloat($0) * (layoutBlueprint.tileHeight + layoutBlueprint.crossSpacing) }
        let nearestColumn = columnCenters.enumerated().min(by: { abs($0.element - localCenter.x) < abs($1.element - localCenter.x) })?.offset ?? 0
        let nearestRow = rowCenters.enumerated().min(by: { abs($0.element - localCenter.y) < abs($1.element - localCenter.y) })?.offset ?? 0
        let clampedColumn = min(max(nearestColumn, 0), layoutBlueprint.columns - 1)
        let clampedRow = min(max(nearestRow, 0), layoutBlueprint.rows - 1)
        let targetIndex = min(max(clampedRow * layoutBlueprint.columns + clampedColumn, 0), vessels.count - 1)
        
        if targetIndex != currentIndex {
            vessels.remove(at: currentIndex)
            vessels.insert(vessel, at: targetIndex)
            tileRowsVessels[0] = vessels
        }
        UIView.animate(withDuration: VibrantConstants.Motion.standardDuration) {
            self.layoutGridRow(vessels, in: container)
        }
    }
}

