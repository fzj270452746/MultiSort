
import Foundation
import UIKit

enum WariantGry: String, Codable, CaseIterable {
    case klasycznyPrzeplyw = "classic_flow"
    case swiadomeTasowanie = "mindful_shuffle"
    
    struct UstawienieCzasomierza: Codable {
        enum Styl: String, Codable {
            case odliczanieWGore
            case odliczanieWDol
        }
        let styl: Styl
        let czasTrwania: Int
    }
    
    var nazwaWyswietlana: String {
        switch self {
        case .klasycznyPrzeplyw:
            return "Classic Flow"
        case .swiadomeTasowanie:
            return "Mindful Shuffle"
        }
    }
    
    var tekstBanera: String {
        switch self {
        case .klasycznyPrzeplyw:
            return "Mode: Classic Flow"
        case .swiadomeTasowanie:
            return "Mode: Mindful Shuffle"
        }
    }
    
    var opisowyTekst: String {
        switch self {
        case .klasycznyPrzeplyw:
            return "Sort freely and chase the highest score."
        case .swiadomeTasowanie:
            return "Follow the reference ordering with limited moves and a ticking clock."
        }
    }
    
    var ustawienieCzasomierza: UstawienieCzasomierza {
        switch self {
        case .klasycznyPrzeplyw:
            return UstawienieCzasomierza(styl: .odliczanieWGore, czasTrwania: 0)
        case .swiadomeTasowanie:
            return UstawienieCzasomierza(styl: .odliczanieWDol, czasTrwania: 180)
        }
    }
    
    var limitRuchow: Int? {
        switch self {
        case .klasycznyPrzeplyw:
            return nil
        case .swiadomeTasowanie:
            return 30
        }
    }
    
    var limitPrzewijania: Int {
        switch self {
        case .klasycznyPrzeplyw:
            return 0
        case .swiadomeTasowanie:
            return 1
        }
    }
    
    var sekwencjeCelow: [[Int]] {
        switch self {
        case .klasycznyPrzeplyw:
            return []
        case .swiadomeTasowanie:
            return [Array(1...9)]
        }
    }
    
    var tytulEtykietyRuchu: String {
        switch self {
        case .klasycznyPrzeplyw:
            return ""
        case .swiadomeTasowanie:
            return "Moves Remaining"
        }
    }
    
    var pozwalaNaTasowanie: Bool {
        switch self {
        case .klasycznyPrzeplyw:
            return true
        case .swiadomeTasowanie:
            return false
        }
    }
    
    var uzywaGornegoUmieszczeniaPodpowiedzi: Bool {
        switch self {
        case .klasycznyPrzeplyw:
            return false
        case .swiadomeTasowanie:
            return true
        }
    }
    
    var uzywaUkladuSiatki: Bool {
        switch self {
        case .klasycznyPrzeplyw:
            return false
        case .swiadomeTasowanie:
            return true
        }
    }
    
    var wymiarySiatki: (wiersze: Int, kolumny: Int) {
        switch self {
        case .klasycznyPrzeplyw:
            return (wiersze: 9, kolumny: 1)
        case .swiadomeTasowanie:
            return (wiersze: 3, kolumny: 3)
        }
    }
    
    var osRuchu: NSLayoutConstraint.Axis {
        switch self {
        case .klasycznyPrzeplyw:
            return .vertical
        case .swiadomeTasowanie:
            return .horizontal
        }
    }
    
    var uzywaPrzelaczaniaKolorow: Bool {
        switch self {
        case .klasycznyPrzeplyw:
            return false
        case .swiadomeTasowanie:
            return true
        }
    }
    
    var domyslnyOdstepKafelkow: CGFloat {
        switch self {
        case .klasycznyPrzeplyw:
            return 4
        case .swiadomeTasowanie:
            return 12
        }
    }
    
    var odstepPrzecinajacyOsi: CGFloat {
        switch self {
        case .klasycznyPrzeplyw:
            return 20
        case .swiadomeTasowanie:
            return 16
        }
    }
    
    var preferowanyProporcjeKafelka: CGFloat {
        switch self {
        case .klasycznyPrzeplyw:
            return 55.0 / 45.0
        case .swiadomeTasowanie:
            return 1.2
        }
    }
    
    static func wariant(dla identyfikator: String) -> WariantGry {
        return WariantGry(rawValue: identyfikator) ?? .klasycznyPrzeplyw
    }
    
    var identyfikator: String { rawValue }
}

struct SkrzynkaPrzewijania: Codable {
    let ukladNaczyn: [[Int]]
    let pozostaleRuchy: Int
}
