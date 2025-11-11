//
//  PodrozGry+Wariant.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/6.
//

import UIKit

extension PodrozGry {
    
    func skonfigurujStanWariantu() {
        sekwencjeCelow = wariant.sekwencjeCelow
        skrzynkiPrzewijania.removeAll()
        skrzynkaPrzedRuchem = nil
        uplywajaceSekundy = 0
        osiagnietyWynik = 0
        pozostaleSekundy = wariant.ustawienieCzasomierza.styl == .odliczanieWDol ? wariant.ustawienieCzasomierza.czasTrwania : 0
        pozostaleRuchy = wariant.limitRuchow ?? 0
        pozostaleTokenyPrzewijania = wariant.limitPrzewijania
        etykietaLimituRuchow.isHidden = true
        etykietaLimituRuchow.text = ""
        etykietaOdznakiWariantu.text = ""
        etykietaOdznakiWariantu.isHidden = true
        czyPodpowiedzWidoczna = false
        if wariant.uzywaPrzelaczaniaKolorow {
            if aktywnyIndeksKoloru >= dostepneKategorie.count {
                aktywnyIndeksKoloru = 0
            }
            przyciskPrzelaczaniaKoloru.isHidden = false
            zaktualizujTytulPrzelaczaczaKoloru()
        } else {
            przyciskPrzelaczaniaKoloru.isHidden = true
        }
        przyciskPodpowiedzi.isEnabled = true
        przyciskPodpowiedzi.alpha = 1.0
        skonfigurujTabliceCelow()
    }
    
    func zaktualizujEtykieteLimituRuchow() {
        if wariant.uzywaUkladuSiatki {
            etykietaLimituRuchow.text = ""
            return
        }
        guard let limit = wariant.limitRuchow else {
            etykietaLimituRuchow.text = ""
            return
        }
        let przyrostek = pozostaleRuchy == 1 ? "move" : "moves"
        etykietaLimituRuchow.text = "\(wariant.tytulEtykietyRuchu): \(pozostaleRuchy)/\(limit) \(przyrostek)"
    }
    
    func zaktualizujStanPrzyciskuPrzewijania() {
        if wariant.uzywaUkladuSiatki {
            przyciskPrzewijania.isEnabled = false
            przyciskPrzewijania.alpha = 0.0
            przyciskPrzewijania.isHidden = true
            return
        }
        guard wariant.limitPrzewijania > 0 else {
            przyciskPrzewijania.isEnabled = false
            przyciskPrzewijania.alpha = 0.4
            return
        }
        let mozePrzewijac = pozostaleTokenyPrzewijania > 0 && !skrzynkiPrzewijania.isEmpty
        przyciskPrzewijania.isEnabled = mozePrzewijac
        przyciskPrzewijania.alpha = mozePrzewijac ? 1.0 : 0.4
    }
    
    func aktualnyZdjecieUlozenia() -> [[Int]] {
        return naczyniaWierszyKafelkow.map { wiersz in
            wiersz.map { $0.element.wartosc }
        }
    }
    
    func przechwycSkrzynkePrzedRuchem() {
        guard wariant.limitRuchow != nil else { return }
        let zdjecie = aktualnyZdjecieUlozenia()
        skrzynkaPrzedRuchem = SkrzynkaPrzewijania(ukladNaczyn: zdjecie, pozostaleRuchy: pozostaleRuchy)
    }
    
    func przetworzZakonczonyRuch() {
        guard wariant.limitRuchow != nil, let przechowanaSkrzynka = skrzynkaPrzedRuchem else { return }
        let najnowszeZdjecie = aktualnyZdjecieUlozenia()
        if najnowszeZdjecie != przechowanaSkrzynka.ukladNaczyn {
            if wariant.limitPrzewijania > 0 {
                skrzynkiPrzewijania.append(przechowanaSkrzynka)
                if skrzynkiPrzewijania.count > wariant.limitPrzewijania {
                    skrzynkiPrzewijania.removeFirst(skrzynkiPrzewijania.count - wariant.limitPrzewijania)
                }
            }
            pozostaleRuchy = max(0, pozostaleRuchy - 1)
            zaktualizujEtykieteLimituRuchow()
            zaktualizujStanPrzyciskuPrzewijania()
            if pozostaleRuchy == 0 {
                wyswietlMonitLimituRuchow()
            }
        }
        skrzynkaPrzedRuchem = nil
    }
    
    func wyswietlMonitLimituRuchow() {
        guard wariant.limitRuchow != nil else { return }
        let wiadomosc: String
        if wariant.limitPrzewijania > 0 && !wariant.uzywaUkladuSiatki {
            wiadomosc = "You've used all moves. Confirm arrangement or use Rewind if available."
        } else {
            wiadomosc = "You've used all moves. Confirm arrangement to continue."
        }
        let alerta = UIAlertController(
            title: "No Moves Remaining",
            message: wiadomosc,
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
    
    func zastosujSkrzynkePrzewijania(_ skrzynka: SkrzynkaPrzewijania) {
        for (indeks, wartosci) in skrzynka.ukladNaczyn.enumerated() {
            guard indeks < naczyniaWierszyKafelkow.count, indeks < konteneryWierszy.count else { continue }
            let istniejacyWiersz = naczyniaWierszyKafelkow[indeks]
            let slownik = Dictionary(uniqueKeysWithValues: istniejacyWiersz.map { ($0.element.wartosc, $0) })
            let przestawione = wartosci.compactMap { slownik[$0] }
            naczyniaWierszyKafelkow[indeks] = przestawione
            if wariant.uzywaUkladuSiatki {
                ulozWierszSiatki(przestawione, w: konteneryWierszy[indeks])
            } else {
                ulozKolumneKafelkow(przestawione, w: konteneryWierszy[indeks])
            }
        }
        pozostaleRuchy = skrzynka.pozostaleRuchy
        zaktualizujEtykieteLimituRuchow()
    }
    
    func obsluzWygasniecieOdliczania() {
        czasomierz?.invalidate()
        osiagnietyWynik = 0
        wyswietlAlertaNiekompletnego(poprawneKolumny: 0, calkowite: naczyniaWierszyKafelkow.count, czyAutomatycznyRestart: true, powod: "Time expired.")
    }
    
    func zaktualizujTytulPrzelaczaczaKoloru() {
        guard wariant.uzywaPrzelaczaniaKolorow else { return }
        let tytul: String
        switch aktywnaKategoria {
        case .kola:
            tytul = "Color: Circles"
        case .bambus:
            tytul = "Color: Bamboo"
        case .znaki:
            tytul = "Color: Characters"
        }
        przyciskPrzelaczaniaKoloru.setTitle(tytul, for: .normal)
        przyciskPrzelaczaniaKoloru.accessibilityLabel = tytul
    }
    
    func przechwycZdjecieSiatki() {
        guard wariant.uzywaUkladuSiatki, let naczynia = naczyniaWierszyKafelkow.first else { return }
        let kolejnosc = naczynia.map { $0.element.wartosc }
        skrzynkiPrzewijania.removeAll()
        pozostaleTokenyPrzewijania = wariant.limitPrzewijania
        let skrzynka = SkrzynkaPrzewijania(ukladNaczyn: [kolejnosc], pozostaleRuchy: pozostaleRuchy)
        skrzynkiPrzewijania.append(skrzynka)
    }
}

