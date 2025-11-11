
import Foundation
import UIKit

struct ElementKafelka {
    let wizerunek: UIImage
    let wartosc: Int
    let kategoria: KategoriaKafelka
    
    enum KategoriaKafelka: String, CaseIterable {
        case kola = "Ltong"
        case bambus = "Mtiao"
        case znaki = "Nwan"
    }
}

class RepozytoriumKafelkow {
    static let singleton = RepozytoriumKafelkow()
    
    let kafelkiKol: [ElementKafelka]
    let kafelkiBambusa: [ElementKafelka]
    let kafelkiZnakow: [ElementKafelka]
    
    private init() {
        kafelkiKol = (1...9).compactMap { indeks in
            guard let wizerunek = UIImage(named: "Ltong \(indeks)") else { return nil }
            return ElementKafelka(wizerunek: wizerunek, wartosc: indeks, kategoria: .kola)
        }
        
        kafelkiBambusa = (1...9).compactMap { indeks in
            guard let wizerunek = UIImage(named: "Mtiao \(indeks)") else { return nil }
            return ElementKafelka(wizerunek: wizerunek, wartosc: indeks, kategoria: .bambus)
        }
        
        kafelkiZnakow = (1...9).compactMap { indeks in
            guard let wizerunek = UIImage(named: "Nwan \(indeks)") else { return nil }
            return ElementKafelka(wizerunek: wizerunek, wartosc: indeks, kategoria: .znaki)
        }
    }
    
    func pobierzKafelkiDlaKategorii(_ kategoria: ElementKafelka.KategoriaKafelka) -> [ElementKafelka] {
        switch kategoria {
        case .kola:
            return kafelkiKol
        case .bambus:
            return kafelkiBambusa
        case .znaki:
            return kafelkiZnakow
        }
    }
    
    func pobierzWszystkieKategorie() -> [[ElementKafelka]] {
        return [kafelkiKol, kafelkiBambusa, kafelkiZnakow]
    }
}
