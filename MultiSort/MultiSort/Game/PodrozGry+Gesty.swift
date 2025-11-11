//
//  PodrozGry+Gesty.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozGry {
    
    @objc func obsluzGestPrzeciagania(_ gest: UIPanGestureRecognizer) {
        guard let naczynie = gest.view as? NaczynieKafelka else { return }
        
        let przesuniecie = gest.translation(in: view)
        
        switch gest.state {
        case .began:
            if let limit = wariant.limitRuchow, limit > 0 && pozostaleRuchy == 0 {
                wyswietlMonitLimituRuchow()
                gest.isEnabled = false
                gest.isEnabled = true
                return
            }
            przeciaganeNaczynie = naczynie
            poczatkowySrodekPrzeciagania = naczynie.center
            
            for (indeksWiersza, wiersz) in naczyniaWierszyKafelkow.enumerated() {
                if wiersz.contains(where: { $0 === naczynie }) {
                    indeksPrzeciaganegoWiersza = indeksWiersza
                    break
                }
            }
            
            przechwycSkrzynkePrzedRuchem()
            
            UIView.animate(withDuration: 0.2) {
                naczynie.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                naczynie.alpha = 0.8
            }
            naczynie.superview?.bringSubviewToFront(naczynie)
            
        case .changed:
            if wariant.uzywaUkladuSiatki {
                naczynie.center = CGPoint(
                    x: poczatkowySrodekPrzeciagania.x + przesuniecie.x,
                    y: poczatkowySrodekPrzeciagania.y + przesuniecie.y
                )
            } else {
                naczynie.center = CGPoint(
                    x: poczatkowySrodekPrzeciagania.x,
                    y: poczatkowySrodekPrzeciagania.y + przesuniecie.y
                )
            }
            
            if !wariant.uzywaUkladuSiatki {
                wykryjMozliwoscZamiany(dla: naczynie, w: indeksPrzeciaganegoWiersza)
            }
            
        case .ended, .cancelled:
            UIView.animate(
                withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy,
                animations: {
                    naczynie.transform = .identity
                    naczynie.alpha = 1.0
                }
            )
            
            if wariant.uzywaUkladuSiatki {
                finalizujUmieszczenieSiatki(dla: naczynie)
            } else {
                przestawWiersz(indeksPrzeciaganegoWiersza)
            }
            przetworzZakonczonyRuch()
            przeciaganeNaczynie = nil
            indeksPrzeciaganegoWiersza = -1
            
        default:
            break
        }
    }
    
    func wykryjMozliwoscZamiany(dla naczynie: NaczynieKafelka, w indeksWiersza: Int) {
        guard indeksWiersza >= 0 && indeksWiersza < naczyniaWierszyKafelkow.count else { return }
        guard !wariant.uzywaUkladuSiatki else { return }
        
        var naczynia = naczyniaWierszyKafelkow[indeksWiersza]
        guard let biezacyIndeks = naczynia.firstIndex(where: { $0 === naczynie }) else { return }
        
        for (indeks, inneNaczynie) in naczynia.enumerated() {
            guard inneNaczynie !== naczynie else { continue }
            
            if wariant.uzywaUkladuSiatki {
                let srodekX = naczynie.frame.midX
                if srodekX > inneNaczynie.frame.minX && srodekX < inneNaczynie.frame.maxX {
                    naczynia.remove(at: biezacyIndeks)
                    naczynia.insert(naczynie, at: indeks)
                    naczyniaWierszyKafelkow[indeksWiersza] = naczynia
                    break
                }
            } else {
                let srodekY = naczynie.frame.midY
                if srodekY > inneNaczynie.frame.minY && srodekY < inneNaczynie.frame.maxY {
                    naczynia.remove(at: biezacyIndeks)
                    naczynia.insert(naczynie, at: indeks)
                    naczyniaWierszyKafelkow[indeksWiersza] = naczynia
                    break
                }
            }
        }
    }
    
    func finalizujUmieszczenieSiatki(dla naczynie: NaczynieKafelka) {
        guard wariant.uzywaUkladuSiatki,
              let kontener = konteneryWierszy.first,
              var naczynia = naczyniaWierszyKafelkow.first,
              let biezacyIndeks = naczynia.firstIndex(where: { $0 === naczynie }) else { return }
        
        let lokalnySrodek = kontener.convert(naczynie.center, from: naczynie.superview)
        let srodkiKolumny = (0..<schematUkladu.kolumny).map { schematUkladu.szerokoscKafelka / 2 + CGFloat($0) * (schematUkladu.szerokoscKafelka + schematUkladu.odstepKafelkow) }
        let srodkiWierszy = (0..<schematUkladu.wiersze).map { schematUkladu.wysokoscKafelka / 2 + CGFloat($0) * (schematUkladu.wysokoscKafelka + schematUkladu.odstepPrzecinajacy) }
        let najblizszaKolumna = srodkiKolumny.enumerated().min(by: { abs($0.element - lokalnySrodek.x) < abs($1.element - lokalnySrodek.x) })?.offset ?? 0
        let najblizszyWiersz = srodkiWierszy.enumerated().min(by: { abs($0.element - lokalnySrodek.y) < abs($1.element - lokalnySrodek.y) })?.offset ?? 0
        let ograniczonaKolumna = min(max(najblizszaKolumna, 0), schematUkladu.kolumny - 1)
        let ograniczonyWiersz = min(max(najblizszyWiersz, 0), schematUkladu.wiersze - 1)
        let indeksDocelowy = min(max(ograniczonyWiersz * schematUkladu.kolumny + ograniczonaKolumna, 0), naczynia.count - 1)
        
        if indeksDocelowy != biezacyIndeks {
            naczynia.remove(at: biezacyIndeks)
            naczynia.insert(naczynie, at: indeksDocelowy)
            naczyniaWierszyKafelkow[0] = naczynia
        }
        UIView.animate(withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy) {
            self.ulozWierszSiatki(naczynia, w: kontener)
        }
    }
}

