//
//  VibrantConstants.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

struct VibrantConstants {
    
    // MARK: - Colors
    struct Palette {
        // 按钮颜色 - 现代配色方案
        static let primaryTint = UIColor(red: 0.40, green: 0.76, blue: 0.64, alpha: 1.0)      // 薄荷绿
        static let secondaryTint = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)   // 橙色
        static let accentTint = UIColor(red: 0.56, green: 0.47, blue: 0.87, alpha: 1.0)      // 紫色
        
        static let overlayDim = UIColor(white: 0.0, alpha: 0.3)
        static let pureWhite = UIColor.white
        static let deepShadow = UIColor(white: 0.0, alpha: 0.6)
    }
    
    // MARK: - Dimensions
    struct Measurements {
        static var tileWidth: CGFloat = 45
        static var tileHeight: CGFloat = 55
        static var tileSpacing: CGFloat = 4
        static let rowSpacing: CGFloat = 16
        static var columnSpacing: CGFloat = 20
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let padding: CGFloat = 20
    }
    
    // MARK: - Animation
    struct Motion {
        static let standardDuration: TimeInterval = 0.3
        static let bounceDuration: TimeInterval = 0.6
        static let springDamping: CGFloat = 0.7
        static let springVelocity: CGFloat = 0.5
    }
    
    // MARK: - Strings
    struct Text {
        static let appTitle = "Mahjong MultiSort"
        static let startGame = "Start Game"
        static let instructions = "Instructions"
        static let records = "Records"
        static let confirmOrder = "Confirm"
        static let shuffle = "Shuffle"
        static let backButton = "Back"
        static let timer = "Time"
        static let score = "Score"
        static let gameComplete = "Congratulations!"
        static let perfectSort = "Perfect Sorting!"
        static let tryAgain = "Try Again"
        static let deleteAll = "Delete All"
        static let noRecords = "No game records yet. Start playing to create your first record!"
        
        // Instructions
        static let instructionsTitle = "How to Play"
        static let instructionsContent = """
        Welcome to Mahjong MultiSort!
        
        📋 Objective:
        Sort all three columns of mahjong tiles in ascending order (1-9).
        
        🎮 How to Play (Click to Swap):
        1. Each column contains 9 tiles of the same suit
        2. Click on a tile to select it (it will highlight)
        3. Click on another tile in the same column to swap their positions
        4. Arrange tiles from smallest to largest (top to bottom)
        5. When ready, tap "Confirm" to check your answer
        
        💡 Tips:
        - Selected tiles will be highlighted with a yellow border
        - Click the same tile again to deselect it
        - You can only swap tiles within the same column (Classic Flow mode)
        
        ⏱️ Scoring:
        - Faster completion = Higher score
        - Perfect sorting = Bonus points
        - Fewer moves used = Higher score
        
        🧠 Mindful Shuffle Mode:
        - Race against a countdown while matching the reference order
        - Tiles appear in a 3×3 grid using a single suit each round
        - Tap the suit switcher to cycle through Bamboo, Circles, and Characters
        - Click two tiles anywhere in the grid to swap their positions
        - Every swap consumes a limited move, so plan carefully!
        - Use the single rewind to undo your last move
        - Confirm before time expires to complete the challenge

        Good luck and have fun!
        """
    }
    
    // MARK: - UserDefaults Keys
    struct StorageKeys {
        static let gameRecords = "com.multisort.gameRecords"
    }
}

