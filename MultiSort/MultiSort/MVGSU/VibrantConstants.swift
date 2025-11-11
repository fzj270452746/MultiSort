
import UIKit

struct StaleZywotne {
    
    struct Paleta {
        static let odcienPodstawowy = UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.0)
        static let odcienDrugorzedny = UIColor(red: 0.85, green: 0.33, blue: 0.24, alpha: 1.0)
        static let odcienAkcentowy = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0)
        static let przyciemnienieNakladki = UIColor(white: 0, alpha: 0.6)
        static let czystyBialy = UIColor.white
        static let glebokiCien = UIColor(white: 0.0, alpha: 0.6)
    }
    
    struct Wymiary {
        static var szerokoscKafelka: CGFloat = 45
        static var wysokoscKafelka: CGFloat = 55
        static var odstepKafelkow: CGFloat = 4
        static let odstepWierszy: CGFloat = 16
        static var odstepKolumn: CGFloat = 20
        static let promienZakraglenia: CGFloat = 12
        static let wysokoscPrzycisku: CGFloat = 50
        static let wciecie: CGFloat = 20
    }
    
    struct Ruch {
        static let czasTrwaniaStandardowy: TimeInterval = 0.3
        static let czasTrwaniaOdbicia: TimeInterval = 0.6
        static let tlumienieSprezyny: CGFloat = 0.7
        static let predkoscSprezyny: CGFloat = 0.5
    }
    
    struct Tekst {
        static let tytulAplikacji = "Mahjong MultiSort"
        static let rozpocznijGre = "Start Game"
        static let instrukcje = "Instructions"
        static let rekordy = "Records"
        static let potwierdzKolejnosc = "Confirm"
        static let tasuj = "Shuffle"
        static let przyciskWstecz = "Back"
        static let czasomierz = "Time"
        static let wynik = "Score"
        static let graZakonczona = "Congratulations!"
        static let idealneSortowanie = "Perfect Sorting!"
        static let sprobujPonownie = "Try Again"
        static let usunWszystko = "Delete All"
        static let brakRekordow = "No game records yet. Start playing to create your first record!"
        
        static let tytulInstrukcji = "How to Play"
        static let trescInstrukcji = """
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
    
    struct KluczeMagazynu {
        static let rekordyGry = "com.multisort.gameRecords"
    }
}
