//
//  GameVoyage+TileManagement.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

struct LayoutBlueprint: Equatable {
    let tileWidth: CGFloat
    let tileHeight: CGFloat
    let tileSpacing: CGFloat       // spacing along movement axis
    let crossSpacing: CGFloat      // spacing between containers across axis
    let primaryLength: CGFloat     // length along primary movement axis
    let secondaryLength: CGFloat   // length along perpendicular axis (used in grids)
    let topOffset: CGFloat
    let rows: Int
    let columns: Int
    let movementAxis: NSLayoutConstraint.Axis
}

extension GameVoyage {
    
    func initializeTileRows() {
        for container in rowContainers {
            container.removeFromSuperview()
        }
        rowContainers.removeAll()
        tileRowsVessels.removeAll()

        layoutBlueprint = forgeLayoutBlueprint()
        VibrantConstants.Measurements.tileWidth = layoutBlueprint.tileWidth
        VibrantConstants.Measurements.tileHeight = layoutBlueprint.tileHeight
        VibrantConstants.Measurements.tileSpacing = layoutBlueprint.tileSpacing
        VibrantConstants.Measurements.columnSpacing = layoutBlueprint.crossSpacing

        if variant.usesGridLayout {
            initializeGridLayout()
        } else {
            initializeColumnLayout()
        }
    }
    
    func forgeLayoutBlueprint() -> LayoutBlueprint {
        if variant.usesGridLayout {
            return forgeGridLayoutBlueprint()
        } else {
            return forgeColumnLayoutBlueprint()
        }
    }
    
    private func forgeColumnLayoutBlueprint() -> LayoutBlueprint {
        let bounds = view.bounds
        let safeInsets = view.safeAreaInsets
        let tileCount: CGFloat = 9
        let spacingCount: CGFloat = tileCount - 1
        let referenceTileHeight: CGFloat = 55
        let referenceTileWidth: CGFloat = 45
        let referenceSpacing: CGFloat = variant.defaultTileSpacing
        let referenceColumnHeight = tileCount * referenceTileHeight + spacingCount * referenceSpacing
        
        let topClearance = safeInsets.top + 120
        let bottomClearance = safeInsets.bottom + 130
        let availableSpace = max(bounds.height - topClearance - bottomClearance, 160)
        
        let rawRatio = availableSpace / referenceColumnHeight
        let minRatio: CGFloat = 0.55
        let maxRatio: CGFloat = 1.25
        let finalRatio = min(max(rawRatio, minRatio), maxRatio)
        
        var tileHeight = max(36, referenceTileHeight * finalRatio)
        var tileSpacing = max(2, referenceSpacing * finalRatio)
        var columnHeight = tileCount * tileHeight + spacingCount * tileSpacing
        
        if columnHeight > availableSpace {
            let compressionRatio = availableSpace / columnHeight
            tileHeight = max(32, tileHeight * compressionRatio)
            tileSpacing = max(2, tileSpacing * compressionRatio)
            columnHeight = tileCount * tileHeight + spacingCount * tileSpacing
        }
        
        let slack = max(0, availableSpace - columnHeight)
        let desiredTopOffset = topClearance + slack / 2
        let maxTopOffset = bounds.height - bottomClearance - columnHeight
        let clampedTopOffset = max(topClearance, min(maxTopOffset, desiredTopOffset))
        let columnSpacing = max(16, min(bounds.width * 0.06, 48))
        let tileWidth = max(34, tileHeight * (referenceTileWidth / referenceTileHeight))
        
        return LayoutBlueprint(
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            tileSpacing: tileSpacing,
            crossSpacing: columnSpacing,
            primaryLength: columnHeight,
            secondaryLength: tileWidth,
            topOffset: clampedTopOffset,
            rows: Int(tileCount),
            columns: TileElement.TileCategory.allCases.count,
            movementAxis: .vertical
        )
    }
    
    private func forgeGridLayoutBlueprint() -> LayoutBlueprint {
        let bounds = view.bounds
        let safeInsets = view.safeAreaInsets
        let dimensions = variant.gridDimensions
        let columns = dimensions.columns
        let rows = dimensions.rows
        let horizontalPadding = VibrantConstants.Measurements.padding
        let availableWidth = max(160, bounds.width - horizontalPadding * 2)
        let desiredSpacing = variant.defaultTileSpacing
        var tileSpacing = desiredSpacing
        var tileWidth = min((availableWidth - CGFloat(columns - 1) * tileSpacing) / CGFloat(columns), 140)
        let aspectRatio = variant.preferredTileAspectRatio // height / width
        var tileHeight = tileWidth * aspectRatio
        
        let topClearance = safeInsets.top + 170
        let bottomClearance = safeInsets.bottom + 150
        let availableHeight = max(bounds.height - topClearance - bottomClearance, 200)
        var rowSpacing = variant.crossAxisSpacing
        var totalHeight = CGFloat(rows) * tileHeight + CGFloat(rows - 1) * rowSpacing
        
        if totalHeight > availableHeight {
            let compressionRatio = availableHeight / totalHeight
            tileHeight = max(60, tileHeight * compressionRatio)
            tileWidth = tileHeight / aspectRatio
            rowSpacing = max(12, rowSpacing * compressionRatio)
            tileSpacing = max(8, tileSpacing * compressionRatio)
            totalHeight = CGFloat(rows) * tileHeight + CGFloat(rows - 1) * rowSpacing
        }
        
        let slack = max(0, availableHeight - totalHeight)
        let topOffset = topClearance + slack / 2
        let containerLength = CGFloat(columns) * tileWidth + CGFloat(columns - 1) * tileSpacing
        return LayoutBlueprint(
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            tileSpacing: tileSpacing,
            crossSpacing: rowSpacing,
            primaryLength: containerLength,
            secondaryLength: totalHeight,
            topOffset: topOffset,
            rows: rows,
            columns: columns,
            movementAxis: .horizontal
        )
    }
    
    private func initializeColumnLayout() {
        let categories = TileRepository.singleton.retrieveAllCategories()
        let screenWidth = view.bounds.width
        let totalColumnsWidth = CGFloat(categories.count) * layoutBlueprint.tileWidth + CGFloat(categories.count - 1) * layoutBlueprint.crossSpacing
        let startX = (screenWidth - totalColumnsWidth) / 2
        
        for (columnIndex, tiles) in categories.enumerated() {
            let shuffledTiles = tiles.shuffled()
            var columnVessels: [TileVessel] = []
            let columnContainer = buildContainerView(tag: 1000 + columnIndex)
            view.addSubview(columnContainer)
            rowContainers.append(columnContainer)
            
            for (index, tile) in shuffledTiles.enumerated() {
                let vessel = TileVessel(element: tile, index: index)
                columnContainer.addSubview(vessel)
                columnVessels.append(vessel)
                attachTapGesture(to: vessel)
            }
            
            tileRowsVessels.append(columnVessels)
            layoutTileColumn(columnVessels, in: columnContainer)
            
            NSLayoutConstraint.activate([
                columnContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startX + CGFloat(columnIndex) * (layoutBlueprint.tileWidth + layoutBlueprint.crossSpacing)),
                columnContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: layoutBlueprint.topOffset),
                columnContainer.widthAnchor.constraint(equalToConstant: layoutBlueprint.tileWidth),
                columnContainer.heightAnchor.constraint(equalToConstant: layoutBlueprint.primaryLength)
            ])
        }
    }
    
    private func initializeGridLayout() {
        let tiles = TileRepository.singleton.retrieveTilesForCategory(activeCategory)
        let shuffledTiles = tiles.shuffled()
        let columns = layoutBlueprint.columns
        let rows = layoutBlueprint.rows
        let totalRowWidth = layoutBlueprint.primaryLength
        let totalHeight = layoutBlueprint.secondaryLength
        let screenWidth = view.bounds.width
        let startX = (screenWidth - totalRowWidth) / 2
        let gridContainer = buildContainerView(tag: 2000)
        view.addSubview(gridContainer)
        rowContainers.append(gridContainer)
        var gridVessels: [TileVessel] = []
        for index in 0..<(rows * columns) {
            guard index < shuffledTiles.count else { break }
            let tile = shuffledTiles[index]
            let vessel = TileVessel(element: tile, index: index)
            gridContainer.addSubview(vessel)
            gridVessels.append(vessel)
            attachTapGesture(to: vessel)
        }
        tileRowsVessels.append(gridVessels)
        layoutGridRow(gridVessels, in: gridContainer)
        NSLayoutConstraint.activate([
            gridContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startX),
            gridContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: layoutBlueprint.topOffset),
            gridContainer.widthAnchor.constraint(equalToConstant: totalRowWidth),
            gridContainer.heightAnchor.constraint(equalToConstant: totalHeight)
        ])
        captureGridSnapshot()
    }
    
    private func buildContainerView(tag: Int) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        container.layer.cornerRadius = VibrantConstants.Measurements.cornerRadius
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        container.tag = tag
        return container
    }
    
    private func attachTapGesture(to vessel: TileVessel) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        vessel.addGestureRecognizer(tapGesture)
        vessel.isUserInteractionEnabled = true
    }
    
    func layoutTileColumn(_ vessels: [TileVessel], in container: UIView) {
        for (index, vessel) in vessels.enumerated() {
            let yOffset = CGFloat(index) * (layoutBlueprint.tileHeight + layoutBlueprint.tileSpacing)
            
            vessel.frame = CGRect(
                x: 0,
                y: yOffset,
                width: layoutBlueprint.tileWidth,
                height: layoutBlueprint.tileHeight
            )
        }
    }
    
    func layoutGridRow(_ vessels: [TileVessel], in container: UIView) {
        for (index, vessel) in vessels.enumerated() {
            let column = index % layoutBlueprint.columns
            let row = index / layoutBlueprint.columns
            let xOffset = CGFloat(column) * (layoutBlueprint.tileWidth + layoutBlueprint.tileSpacing)
            let yOffset = CGFloat(row) * (layoutBlueprint.tileHeight + layoutBlueprint.crossSpacing)
            vessel.frame = CGRect(
                x: xOffset,
                y: yOffset,
                width: layoutBlueprint.tileWidth,
                height: layoutBlueprint.tileHeight
            )
        }
    }
    
    func rearrangeRow(_ rowIndex: Int) {
        guard rowIndex >= 0 && rowIndex < tileRowsVessels.count else { return }
        
        let vessels = tileRowsVessels[rowIndex]
        let container = rowContainers[rowIndex]
        
        for (index, vessel) in vessels.enumerated() {
            vessel.currentIndex = index
            
            UIView.animate(
                withDuration: VibrantConstants.Motion.standardDuration,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    vessel.removeFromSuperview()
                    container.addSubview(vessel)
                    if self.variant.usesGridLayout {
                        let xOffset = CGFloat(index) * (self.layoutBlueprint.tileWidth + self.layoutBlueprint.tileSpacing)
                        vessel.frame = CGRect(
                            x: xOffset,
                            y: 0,
                            width: self.layoutBlueprint.tileWidth,
                            height: self.layoutBlueprint.tileHeight
                        )
                    } else {
                        let yOffset = CGFloat(index) * (self.layoutBlueprint.tileHeight + self.layoutBlueprint.tileSpacing)
                        vessel.frame = CGRect(
                            x: 0,
                            y: yOffset,
                            width: self.layoutBlueprint.tileWidth,
                            height: self.layoutBlueprint.tileHeight
                        )
                    }
                }
            )
        }
    }
    
    func shuffleAllRows() {
        rewindCrates.removeAll()
        preMoveCrate = nil
        rewindTokensRemaining = variant.rewindAllowance
        for rowIndex in 0..<tileRowsVessels.count {
            tileRowsVessels[rowIndex].shuffle()
            rearrangeRow(rowIndex)
        }
        
        hasRevealed = false
        for row in tileRowsVessels {
            for vessel in row {
                vessel.concealMagnitude()
            }
        }
        updateMoveQuotaLabel()
        updateRewindButtonState()
        updateSuitSwitcherTitle()
    }
    
    func revealAllMagnitudes() {
        for row in tileRowsVessels {
            for vessel in row {
                vessel.revealMagnitude()
            }
        }
        hasRevealed = true
    }
    
    func hideAllMagnitudes() {
        for row in tileRowsVessels {
            for vessel in row {
                vessel.concealMagnitude()
            }
        }
    }
}

