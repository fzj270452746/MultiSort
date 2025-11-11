//
//  GameVariant.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/6.
//

import Foundation
import UIKit

// MARK: - GameVariant
enum GameVariant: String, Codable, CaseIterable {
    case classicFlow = "classic_flow"
    case mindfulShuffle = "mindful_shuffle"
    
    struct TimerDisposition: Codable {
        enum Style: String, Codable {
            case countUp
            case countDown
        }
        let style: Style
        let span: Int
    }
    
    var displayName: String {
        switch self {
        case .classicFlow:
            return "Classic Flow"
        case .mindfulShuffle:
            return "Mindful Shuffle"
        }
    }
    
    var bannerText: String {
        switch self {
        case .classicFlow:
            return "Mode: Classic Flow"
        case .mindfulShuffle:
            return "Mode: Mindful Shuffle"
        }
    }
    
    var descriptiveBlurb: String {
        switch self {
        case .classicFlow:
            return "Sort freely and chase the highest score."
        case .mindfulShuffle:
            return "Follow the reference ordering with limited moves and a ticking clock."
        }
    }
    
    var timerDisposition: TimerDisposition {
        switch self {
        case .classicFlow:
            return TimerDisposition(style: .countUp, span: 0)
        case .mindfulShuffle:
            return TimerDisposition(style: .countDown, span: 180)
        }
    }
    
    var moveAllowance: Int? {
        switch self {
        case .classicFlow:
            return nil
        case .mindfulShuffle:
            return 30
        }
    }
    
    var rewindAllowance: Int {
        switch self {
        case .classicFlow:
            return 0
        case .mindfulShuffle:
            return 1
        }
    }
    
    var objectiveSequences: [[Int]] {
        switch self {
        case .classicFlow:
            return []
        case .mindfulShuffle:
            return [Array(1...9)]
        }
    }
    
    var moveLabelTitle: String {
        switch self {
        case .classicFlow:
            return ""
        case .mindfulShuffle:
            return "Moves Remaining"
        }
    }
    
    var allowsShuffle: Bool {
        switch self {
        case .classicFlow:
            return true
        case .mindfulShuffle:
            return false
        }
    }
    
    var usesTopHintPlacement: Bool {
        switch self {
        case .classicFlow:
            return false
        case .mindfulShuffle:
            return true
        }
    }
    
    var usesGridLayout: Bool {
        switch self {
        case .classicFlow:
            return false
        case .mindfulShuffle:
            return true
        }
    }
    
    var gridDimensions: (rows: Int, columns: Int) {
        switch self {
        case .classicFlow:
            return (rows: 9, columns: 1)
        case .mindfulShuffle:
            return (rows: 3, columns: 3)
        }
    }
    
    var movementAxis: NSLayoutConstraint.Axis {
        switch self {
        case .classicFlow:
            return .vertical
        case .mindfulShuffle:
            return .horizontal
        }
    }
    
    var usesSuitCycler: Bool {
        switch self {
        case .classicFlow:
            return false
        case .mindfulShuffle:
            return true
        }
    }
    
    var defaultTileSpacing: CGFloat {
        switch self {
        case .classicFlow:
            return 4
        case .mindfulShuffle:
            return 12
        }
    }
    
    var crossAxisSpacing: CGFloat {
        switch self {
        case .classicFlow:
            return 20
        case .mindfulShuffle:
            return 16
        }
    }
    
    var preferredTileAspectRatio: CGFloat {
        switch self {
        case .classicFlow:
            return 55.0 / 45.0
        case .mindfulShuffle:
            return 1.2
        }
    }
    
    static func variant(for identifier: String) -> GameVariant {
        return GameVariant(rawValue: identifier) ?? .classicFlow
    }
    
    var identifier: String { rawValue }
}

// MARK: - RewindCrate
struct RewindCrate: Codable {
    let vesselArrangement: [[Int]]
    let movesRemaining: Int
}

