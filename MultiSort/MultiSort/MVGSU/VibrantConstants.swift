

import UIKit

struct VibrantConstants {
    
    // MARK: - Colors
    struct Palette {
        static let primaryTint = UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.0)
        static let secondaryTint = UIColor(red: 0.85, green: 0.33, blue: 0.24, alpha: 1.0)
        static let accentTint = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0)
        static let overlayDim = UIColor(white: 0, alpha: 0.6)
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
        
        🎮 How to Play:
        1. Each column contains 9 tiles of the same suit
        2. Tap and drag tiles to change their positions
        3. Arrange tiles from smallest to largest (top to bottom)
        4. When ready, tap "Confirm" to check your answer
        
        ⏱️ Scoring:
        - Faster completion = Higher score
        - Perfect sorting = Bonus points
        
        🧠 Mindful Shuffle Mode:
        - Race against a countdown while matching the reference order
        - Tiles appear in a 3×3 grid using a single suit each round
        - Tap the suit switcher to cycle through Bamboo, Circles, and Characters
        - Drag tiles freely（up, down, left, right）to form 1→9 across the entire grid
        - Every drag consumes a limited move, so plan carefully
        - Use the single rewind to undo your last decision, then confirm before time expires

        Good luck and have fun!
        """
    }
    
    // MARK: - UserDefaults Keys
    struct StorageKeys {
        static let gameRecords = "com.multisort.gameRecords"
    }
}

