//
//  PodrozGry+Czasomierz.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozGry {
    
    func rozpoczniCzasomierz() {
        czasomierz?.invalidate()
        uplywajaceSekundy = 0
        switch wariant.ustawienieCzasomierza.styl {
        case .odliczanieWGore:
            break
        case .odliczanieWDol:
            pozostaleSekundy = wariant.ustawienieCzasomierza.czasTrwania
        }
        zaktualizujWyswietlanieCzasomierza()
        zaplanujCzasomierz()
    }
    
    func zaktualizujWyswietlanieCzasomierza() {
        switch wariant.ustawienieCzasomierza.styl {
        case .odliczanieWGore:
            etykietaCzasomierza.text = "\(StaleZywotne.Tekst.czasomierz): \(sformatujUplywajacyCzas(uplywajaceSekundy))"
        case .odliczanieWDol:
            etykietaCzasomierza.text = "Remaining time: \(sformatujUplywajacyCzas(pozostaleSekundy))"
        }
    }
    
    func zaktualizujWyswietlanieWyniku() {
        etykietaWyniku.text = "\(StaleZywotne.Tekst.wynik): \(osiagnietyWynik)"
    }
    
    func sformatujUplywajacyCzas(_ wartoscSekund: Int) -> String {
        let minuty = wartoscSekund / 60
        let sekundy = wartoscSekund % 60
        return String(format: "%02d:%02d", minuty, sekundy)
    }
    
    func zaplanujCzasomierz() {
        czasomierz?.invalidate()
        switch wariant.ustawienieCzasomierza.styl {
        case .odliczanieWGore:
            czasomierz = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.uplywajaceSekundy += 1
                self.zaktualizujWyswietlanieCzasomierza()
            }
        case .odliczanieWDol:
            guard pozostaleSekundy > 0 else { return }
            czasomierz = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.pozostaleSekundy = max(0, self.pozostaleSekundy - 1)
                let calkowity = self.wariant.ustawienieCzasomierza.czasTrwania
                self.uplywajaceSekundy = calkowity - self.pozostaleSekundy
                self.zaktualizujWyswietlanieCzasomierza()
                if self.pozostaleSekundy == 0 {
                    self.czasomierz?.invalidate()
                    self.obsluzWygasniecieOdliczania()
                }
            }
        }
    }
    
    func wznowCzasomierzPoPauzie() {
        zaplanujCzasomierz()
    }
}

