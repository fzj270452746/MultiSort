//
//  PodrozGry+Akcje.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozGry {
    
    @objc func wcisnietoPowrot() {
        przyciskPowrotu.animujOdbicie()
        
        czasomierz?.invalidate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: false)  // 禁用动画避免闪烁
        }
    }
    
    @objc func wcisnietoPotwierdzenie() {
        przyciskPotwierdzenia.animujOdbicie()
        
        ujawnijWszystkieWartosci()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.ocenUlozenie()
        }
    }
    
    @objc func wcisnietoTasowanie() {
        guard wariant.pozwalaNaTasowanie else { return }
        przyciskTasowania.animujOdbicie()
        zresetujOdpowiedzKolumny()
        przetasujWszystkieWiersze()
    }
    
    @objc func wcisnietoPodpowiedz(_ nadawca: UIButton) {
        nadawca.animujOdbicie()
        przelaczWszystkieWartosci()
        
        let kolorPrzycisku = czyPodpowiedzWidoczna ? UIColor(red: 0.85, green: 0.65, blue: 0.35, alpha: 1.0) : UIColor(red: 0.95, green: 0.55, blue: 0.25, alpha: 1.0)
        UIView.animate(withDuration: 0.3) {
            nadawca.backgroundColor = kolorPrzycisku
            self.przyciskPodpowiedzi.backgroundColor = kolorPrzycisku
        }
    }
    
    @objc func wcisnietoPrzewijanie() {
        guard wariant.limitPrzewijania > 0 else { return }
        guard pozostaleTokenyPrzewijania > 0 else {
            let alerta = UIAlertController(
                title: "No Rewind Available",
                message: "You've already used the available rewind in this round.",
                preferredStyle: .alert
            )
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        guard let skrzynka = skrzynkiPrzewijania.popLast() else {
            let alerta = UIAlertController(
                title: "Nothing to Rewind",
                message: "You must make a move before using rewind.",
                preferredStyle: .alert
            )
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
            return
        }
        przyciskPrzewijania.animujOdbicie()
        zastosujSkrzynkePrzewijania(skrzynka)
        pozostaleTokenyPrzewijania -= 1
        zaktualizujStanPrzyciskuPrzewijania()
        zresetujOdpowiedzKolumny()
    }
    
    @objc func wcisnietoPoddanie() {
        przyciskPoddania.animujOdbicie()
        czasomierz?.invalidate()
        let alerta = UIAlertController(
            title: "Give Up?",
            message: "Do you want to abandon this round and shuffle?",
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.wznowCzasomierzPoPauzie()
        }))
        alerta.addAction(UIAlertAction(title: "Give Up", style: .destructive, handler: { [weak self] _ in
            self?.zresetujGre()
        }))
        present(alerta, animated: true)
    }
    
    @objc func wcisnietoPrzelaczaczKoloru() {
        guard wariant.uzywaPrzelaczaniaKolorow else { return }
        przyciskPrzelaczaniaKoloru.animujOdbicie()
        aktywnyIndeksKoloru = (aktywnyIndeksKoloru + 1) % max(dostepneKategorie.count, 1)
        zaktualizujTytulPrzelaczaczaKoloru()
        zresetujGre()
    }
    
    func ocenUlozenie() {
        var czyIdealne = true
        var poprawneKolumny = 0
        
        for (indeks, wiersz) in naczyniaWierszyKafelkow.enumerated() {
            let wartosci = wiersz.map { $0.element.wartosc }
            let oczekiwanaSekwencja: [Int]?
            if indeks < sekwencjeCelow.count {
                oczekiwanaSekwencja = sekwencjeCelow[indeks]
            } else {
                oczekiwanaSekwencja = nil
            }
            let czyPoprawne: Bool
            if let oczekiwana = oczekiwanaSekwencja, !oczekiwana.isEmpty {
                czyPoprawne = wartosci == oczekiwana
            } else {
                let posortowaneWartosci = wartosci.sorted()
                czyPoprawne = wartosci == posortowaneWartosci
            }
            
            if czyPoprawne {
                poprawneKolumny += 1
                pokazOdpowiedzKolumny(na: indeks, czyPoprawne: true)
            } else {
                czyIdealne = false
                pokazOdpowiedzKolumny(na: indeks, czyPoprawne: false)
            }
        }
        
        czasomierz?.invalidate()
        
        let uzyteRuchy: Int?
        if let limit = wariant.limitRuchow {
            uzyteRuchy = limit - pozostaleRuchy
        } else {
            uzyteRuchy = nil
        }
        let pozostalyCzas = wariant.ustawienieCzasomierza.styl == .odliczanieWDol ? pozostaleSekundy : 0
        let calkowityCzas = wariant.ustawienieCzasomierza.czasTrwania
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            self.osiagnietyWynik = self.obliczWynik(czyIdealne: czyIdealne, uzyteRuchy: uzyteRuchy, pozostalyCzas: pozostalyCzas, calkowityCzas: calkowityCzas)
            self.zachowajPamiatkeGry(czyIdealne: czyIdealne, uzyteRuchy: uzyteRuchy, pozostalyCzas: pozostalyCzas, calkowityCzas: calkowityCzas)
            self.zaktualizujWyswietlanieWyniku()
            
            if czyIdealne {
                self.wyswietlAlertaZwyciestwa(czyAutomatycznyRestart: true)
            } else {
                self.wyswietlAlertaNiekompletnego(poprawneKolumny: poprawneKolumny, calkowite: self.naczyniaWierszyKafelkow.count, czyAutomatycznyRestart: true, powod: nil)
            }
        }
    }
    
    func pokazOdpowiedzKolumny(na indeksKolumny: Int, czyPoprawne: Bool) {
        guard indeksKolumny < konteneryWierszy.count else { return }
        let kontener = konteneryWierszy[indeksKolumny]
        
        let kolorOdpowiedzi: UIColor
        let kolorTla: UIColor
        
        if czyPoprawne {
            kolorOdpowiedzi = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0)
            kolorTla = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 0.2)
        } else {
            kolorOdpowiedzi = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
            kolorTla = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.2)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                kontener.layer.borderColor = kolorOdpowiedzi.cgColor
                kontener.layer.borderWidth = 4
                kontener.backgroundColor = kolorTla
            }
        )
        
        let widokIkony = utworzIkoneOdpowiedzi(czyPoprawne: czyPoprawne)
        widokIkony.center = CGPoint(x: kontener.bounds.width / 2, y: -30)
        widokIkony.alpha = 0
        kontener.addSubview(widokIkony)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                widokIkony.alpha = 1.0
                widokIkony.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        )
    }
    
    func utworzIkoneOdpowiedzi(czyPoprawne: Bool) -> UIView {
        let kontenerWidoku = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        kontenerWidoku.backgroundColor = czyPoprawne ? 
            UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1.0) :
            UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        kontenerWidoku.layer.cornerRadius = 20
        kontenerWidoku.layer.shadowColor = UIColor.black.cgColor
        kontenerWidoku.layer.shadowOffset = CGSize(width: 0, height: 2)
        kontenerWidoku.layer.shadowOpacity = 0.3
        kontenerWidoku.layer.shadowRadius = 4
        
        let widokObrazuIkony = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        let konfiguracja = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let nazwaIkony = czyPoprawne ? "checkmark" : "xmark"
        widokObrazuIkony.image = UIImage(systemName: nazwaIkony, withConfiguration: konfiguracja)
        widokObrazuIkony.tintColor = .white
        widokObrazuIkony.contentMode = .scaleAspectFit
        
        kontenerWidoku.addSubview(widokObrazuIkony)
        return kontenerWidoku
    }
    
    func obliczWynik(czyIdealne: Bool, uzyteRuchy: Int?, pozostalyCzas: Int, calkowityCzas: Int) -> Int {
        switch wariant {
        case .klasycznyPrzeplyw:
            let wynikBazowy = 1000
            let premiaCzasowa = max(0, 300 - uplywajaceSekundy) * 10
            let premiaIdealna = czyIdealne ? 500 : 0
            return wynikBazowy + premiaCzasowa + premiaIdealna
        case .swiadomeTasowanie:
            let wynikBazowy = 1500
            let premiaPozostalych = max(0, (wariant.limitRuchow ?? 0) - (uzyteRuchy ?? 0)) * 60
            let premiaCzasowa = max(0, pozostalyCzas) * 40
            let premiaIdealna = czyIdealne ? 800 : 0
            return wynikBazowy + premiaPozostalych + premiaCzasowa + premiaIdealna
        }
    }
    
    func wyswietlAlertaZwyciestwa(czyAutomatycznyRestart: Bool) {
        let deskryptorCzasu: String
        var dodatkowySzczegolOdliczania = ""
        switch wariant.ustawienieCzasomierza.styl {
        case .odliczanieWGore:
            deskryptorCzasu = "\(StaleZywotne.Tekst.czasomierz): \(sformatujUplywajacyCzas(uplywajaceSekundy))"
        case .odliczanieWDol:
            deskryptorCzasu = "Time used: \(sformatujUplywajacyCzas(uplywajaceSekundy))"
            dodatkowySzczegolOdliczania = "\nRemaining time: \(sformatujUplywajacyCzas(pozostaleSekundy))"
        }
        var wiadomosc = "\(StaleZywotne.Tekst.idealneSortowanie)\n\n\(StaleZywotne.Tekst.wynik): \(osiagnietyWynik)\n\(deskryptorCzasu)\(dodatkowySzczegolOdliczania)"
        if let limit = wariant.limitRuchow {
            let uzyte = limit - pozostaleRuchy
            wiadomosc += "\nMoves used: \(uzyte)/\(limit)"
        }
        wiadomosc += "\n\n" + (czyAutomatycznyRestart ? "Starting new round..." : "")
        
        let alerta = UIAlertController(
            title: StaleZywotne.Tekst.graZakonczona,
            message: wiadomosc,
            preferredStyle: .alert
        )
        
        present(alerta, animated: true)
        
        if czyAutomatycznyRestart {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                alerta.dismiss(animated: true) {
                    self?.zresetujGre()
                }
            }
        }
    }
    
    func wyswietlAlertaNiekompletnego(poprawneKolumny: Int, calkowite: Int, czyAutomatycznyRestart: Bool, powod: String?) {
        let deskryptorCzasu: String
        var dodatkowySzczegolOdliczania = ""
        switch wariant.ustawienieCzasomierza.styl {
        case .odliczanieWGore:
            deskryptorCzasu = "\(StaleZywotne.Tekst.czasomierz): \(sformatujUplywajacyCzas(uplywajaceSekundy))"
        case .odliczanieWDol:
            deskryptorCzasu = "Time used: \(sformatujUplywajacyCzas(uplywajaceSekundy))"
            dodatkowySzczegolOdliczania = "\nRemaining time: \(sformatujUplywajacyCzas(pozostaleSekundy))"
        }
        var wiadomosc = "You successfully arranged \(poprawneKolumny) out of \(calkowite) sets correctly!\n\n\(StaleZywotne.Tekst.wynik): \(osiagnietyWynik)\n\(deskryptorCzasu)\(dodatkowySzczegolOdliczania)"
        if let limit = wariant.limitRuchow {
            let uzyte = limit - pozostaleRuchy
            wiadomosc += "\nMoves used: \(uzyte)/\(limit)"
        }
        if let powod = powod {
            wiadomosc += "\n\n\(powod)"
        }
        wiadomosc += "\n\n" + (czyAutomatycznyRestart ? "Starting new round..." : "")
        
        let alerta = UIAlertController(
            title: StaleZywotne.Tekst.sprobujPonownie,
            message: wiadomosc,
            preferredStyle: .alert
        )
        
        present(alerta, animated: true)
        
        if czyAutomatycznyRestart {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                alerta.dismiss(animated: true) {
                    self?.zresetujGre()
                }
            }
        }
    }
    
    func zresetujOdpowiedzKolumny() {
        for kontener in konteneryWierszy {
            for widokPodrzędny in kontener.subviews {
                if widokPodrzędny.frame.origin.y < 0 {
                    widokPodrzędny.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.3) {
                kontener.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
                kontener.layer.borderWidth = 2
                kontener.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            }
        }
    }
    
    func zresetujGre() {
        czasomierz?.invalidate()
        skonfigurujStanWariantu()
        zainicjalizujWierszeKafelkow()
        zresetujOdpowiedzKolumny()
        if wariant.uzywaUkladuSiatki, let skrzynka = skrzynkiPrzewijania.last {
            zastosujSkrzynkePrzewijania(skrzynka)
        } else {
            przetasujWszystkieWiersze()
        }
        czyUjawniono = false
        czyPodpowiedzWidoczna = false
        zaktualizujWyswietlanieCzasomierza()
        zaktualizujWyswietlanieWyniku()
        
        UIView.animate(withDuration: 0.3) {
            self.przyciskPodpowiedzi.backgroundColor = UIColor(red: 0.95, green: 0.55, blue: 0.25, alpha: 1.0)
            self.przyciskPodpowiedzi.alpha = 1.0
        }
        przyciskPodpowiedzi.isEnabled = true
        zaktualizujEtykieteLimituRuchow()
        zaktualizujStanPrzyciskuPrzewijania()
        zaktualizujTytulPrzelaczaczaKoloru()
        rozpoczniCzasomierz()
    }
    
    func zachowajPamiatkeGry(czyIdealne: Bool, uzyteRuchy: Int?, pozostalyCzas: Int, calkowityCzas: Int) {
        let zarejestrowanyUplyw: Int
        switch wariant.ustawienieCzasomierza.styl {
        case .odliczanieWGore:
            zarejestrowanyUplyw = uplywajaceSekundy
        case .odliczanieWDol:
            zarejestrowanyUplyw = calkowityCzas - pozostalyCzas
        }
        let zapamietaneRuchy = uzyteRuchy ?? wariant.limitRuchow.map { $0 - pozostaleRuchy }
        let rezerwaCzasu = wariant.ustawienieCzasomierza.styl == .odliczanieWDol ? pozostalyCzas : nil
        let pamiatka = PamiatkaGry(
            znacznikCzasu: Date(),
            uplywajaceSekundy: zarejestrowanyUplyw,
            osiagnietyWynik: osiagnietyWynik,
            byloIdealne: czyIdealne,
            identyfikatorWariantu: wariant.identyfikator,
            sladRuchu: zapamietaneRuchy,
            czasRezydualny: rezerwaCzasu,
            uzytoPrzewijania: pozostaleTokenyPrzewijania < wariant.limitPrzewijania
        )
        ArchiwumWynikow.singleton.zachowajPamiatke(pamiatka)
    }
}

