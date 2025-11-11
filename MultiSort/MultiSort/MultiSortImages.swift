//
//  MultiSortImages.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import Foundation
import UIKit

// MARK: - TileElement Structure
struct TileElement {
    let portrayal: UIImage
    let magnitude: Int
    let category: TileCategory
    
    enum TileCategory: String, CaseIterable {
        case circles = "Ltong"
        case bamboo = "Mtiao"
        case characters = "Nwan"
    }
}

// MARK: - TileRepository
class TileRepository {
    static let singleton = TileRepository()
    
    let circlesTiles: [TileElement]
    let bambooTiles: [TileElement]
    let charactersTiles: [TileElement]
    
    private init() {
        circlesTiles = (1...9).compactMap { index in
            guard let portrayal = UIImage(named: "Ltong \(index)") else { return nil }
            return TileElement(portrayal: portrayal, magnitude: index, category: .circles)
        }
        
        bambooTiles = (1...9).compactMap { index in
            guard let portrayal = UIImage(named: "Mtiao \(index)") else { return nil }
            return TileElement(portrayal: portrayal, magnitude: index, category: .bamboo)
        }
        
        charactersTiles = (1...9).compactMap { index in
            guard let portrayal = UIImage(named: "Nwan \(index)") else { return nil }
            return TileElement(portrayal: portrayal, magnitude: index, category: .characters)
        }
    }
    
    func retrieveTilesForCategory(_ category: TileElement.TileCategory) -> [TileElement] {
        switch category {
        case .circles:
            return circlesTiles
        case .bamboo:
            return bambooTiles
        case .characters:
            return charactersTiles
        }
    }
    
    func retrieveAllCategories() -> [[TileElement]] {
        return [circlesTiles, bambooTiles, charactersTiles]
    }
}