//
//  PodrozGry+ZarzadzanieKafelkami.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

struct SchematUkladu: Equatable {
    let szerokoscKafelka: CGFloat
    let wysokoscKafelka: CGFloat
    let odstepKafelkow: CGFloat
    let odstepPrzecinajacy: CGFloat
    let dlugoscGlowna: CGFloat
    let dlugoscDruga: CGFloat
    let przesuniecieGorne: CGFloat
    let wiersze: Int
    let kolumny: Int
    let osRuchu: NSLayoutConstraint.Axis
}

extension PodrozGry {
    
    func zainicjalizujWierszeKafelkow() {
        for kontener in konteneryWierszy {
            kontener.removeFromSuperview()
        }
        konteneryWierszy.removeAll()
        naczyniaWierszyKafelkow.removeAll()

        schematUkladu = utworzSchematUkladu()
        StaleZywotne.Wymiary.szerokoscKafelka = schematUkladu.szerokoscKafelka
        StaleZywotne.Wymiary.wysokoscKafelka = schematUkladu.wysokoscKafelka
        StaleZywotne.Wymiary.odstepKafelkow = schematUkladu.odstepKafelkow
        StaleZywotne.Wymiary.odstepKolumn = schematUkladu.odstepPrzecinajacy

        if wariant.uzywaUkladuSiatki {
            zainicjalizujUkladSiatki()
        } else {
            zainicjalizujUkladKolumnowy()
        }
    }
    
    func utworzSchematUkladu() -> SchematUkladu {
        if wariant.uzywaUkladuSiatki {
            return utworzSchematUkladuSiatki()
        } else {
            return utworzSchematUkladuKolumnowego()
        }
    }
    
    private func utworzSchematUkladuKolumnowego() -> SchematUkladu {
        let granice = view.bounds
        let bezpieczneWciecia = view.safeAreaInsets
        let liczbaKafelkow: CGFloat = 9
        let liczbaOdstepow: CGFloat = liczbaKafelkow - 1
        let referencyjnaWysokoscKafelka: CGFloat = 55
        let referencyjnaSzerokoscKafelka: CGFloat = 45
        let referencyjnyOdstep: CGFloat = wariant.domyslnyOdstepKafelkow
        let referencyjnaWysokoscKolumny = liczbaKafelkow * referencyjnaWysokoscKafelka + liczbaOdstepow * referencyjnyOdstep
        
        let gorneOdstepy = bezpieczneWciecia.top + 120
        let dolneOdstepy = bezpieczneWciecia.bottom + 130
        let dostepnaPrzestrzen = max(granice.height - gorneOdstepy - dolneOdstepy, 160)
        
        let surowyWspolczynnik = dostepnaPrzestrzen / referencyjnaWysokoscKolumny
        let minimalnyWspolczynnik: CGFloat = 0.55
        let maksymalnyWspolczynnik: CGFloat = 1.25
        let koncowyWspolczynnik = min(max(surowyWspolczynnik, minimalnyWspolczynnik), maksymalnyWspolczynnik)
        
        var wysokoscKafelka = max(36, referencyjnaWysokoscKafelka * koncowyWspolczynnik)
        var odstepKafelkow = max(2, referencyjnyOdstep * koncowyWspolczynnik)
        var wysokoscKolumny = liczbaKafelkow * wysokoscKafelka + liczbaOdstepow * odstepKafelkow
        
        if wysokoscKolumny > dostepnaPrzestrzen {
            let wspolczynnikKompresji = dostepnaPrzestrzen / wysokoscKolumny
            wysokoscKafelka = max(32, wysokoscKafelka * wspolczynnikKompresji)
            odstepKafelkow = max(2, odstepKafelkow * wspolczynnikKompresji)
            wysokoscKolumny = liczbaKafelkow * wysokoscKafelka + liczbaOdstepow * odstepKafelkow
        }
        
        let luz = max(0, dostepnaPrzestrzen - wysokoscKolumny)
        let pozadanePrzesuniecieGorne = gorneOdstepy + luz / 2
        let maksymalnePrzesuniecieGorne = granice.height - dolneOdstepy - wysokoscKolumny
        let ograniczonePrzesuniecieGorne = max(gorneOdstepy, min(maksymalnePrzesuniecieGorne, pozadanePrzesuniecieGorne))
        let odstepKolumnowy = max(16, min(granice.width * 0.06, 48))
        let szerokoscKafelka = max(34, wysokoscKafelka * (referencyjnaSzerokoscKafelka / referencyjnaWysokoscKafelka))
        
        return SchematUkladu(
            szerokoscKafelka: szerokoscKafelka,
            wysokoscKafelka: wysokoscKafelka,
            odstepKafelkow: odstepKafelkow,
            odstepPrzecinajacy: odstepKolumnowy,
            dlugoscGlowna: wysokoscKolumny,
            dlugoscDruga: szerokoscKafelka,
            przesuniecieGorne: ograniczonePrzesuniecieGorne,
            wiersze: Int(liczbaKafelkow),
            kolumny: ElementKafelka.KategoriaKafelka.allCases.count,
            osRuchu: .vertical
        )
    }
    
    private func utworzSchematUkladuSiatki() -> SchematUkladu {
        let granice = view.bounds
        let bezpieczneWciecia = view.safeAreaInsets
        let wymiary = wariant.wymiarySiatki
        let kolumny = wymiary.kolumny
        let wiersze = wymiary.wiersze
        let poziomeWciecie = StaleZywotne.Wymiary.wciecie
        let dostepnaSzerokosc = max(160, granice.width - poziomeWciecie * 2)
        let pozadanyOdstep = wariant.domyslnyOdstepKafelkow
        var odstepKafelkow = pozadanyOdstep
        var szerokoscKafelka = min((dostepnaSzerokosc - CGFloat(kolumny - 1) * odstepKafelkow) / CGFloat(kolumny), 140)
        let proporcje = wariant.preferowanyProporcjeKafelka
        var wysokoscKafelka = szerokoscKafelka * proporcje
        
        let gorneOdstepy = bezpieczneWciecia.top + 170
        let dolneOdstepy = bezpieczneWciecia.bottom + 150
        let dostepnaWysokosc = max(granice.height - gorneOdstepy - dolneOdstepy, 200)
        var odstepWierszy = wariant.odstepPrzecinajacyOsi
        var calkowitaWysokosc = CGFloat(wiersze) * wysokoscKafelka + CGFloat(wiersze - 1) * odstepWierszy
        
        if calkowitaWysokosc > dostepnaWysokosc {
            let wspolczynnikKompresji = dostepnaWysokosc / calkowitaWysokosc
            wysokoscKafelka = max(60, wysokoscKafelka * wspolczynnikKompresji)
            szerokoscKafelka = wysokoscKafelka / proporcje
            odstepWierszy = max(12, odstepWierszy * wspolczynnikKompresji)
            odstepKafelkow = max(8, odstepKafelkow * wspolczynnikKompresji)
            calkowitaWysokosc = CGFloat(wiersze) * wysokoscKafelka + CGFloat(wiersze - 1) * odstepWierszy
        }
        
        let luz = max(0, dostepnaWysokosc - calkowitaWysokosc)
        let przesuniecieGorne = gorneOdstepy + luz / 2
        let dlugoscKontenera = CGFloat(kolumny) * szerokoscKafelka + CGFloat(kolumny - 1) * odstepKafelkow
        return SchematUkladu(
            szerokoscKafelka: szerokoscKafelka,
            wysokoscKafelka: wysokoscKafelka,
            odstepKafelkow: odstepKafelkow,
            odstepPrzecinajacy: odstepWierszy,
            dlugoscGlowna: dlugoscKontenera,
            dlugoscDruga: calkowitaWysokosc,
            przesuniecieGorne: przesuniecieGorne,
            wiersze: wiersze,
            kolumny: kolumny,
            osRuchu: .horizontal
        )
    }
    
    private func zainicjalizujUkladKolumnowy() {
        let kategorie = RepozytoriumKafelkow.singleton.pobierzWszystkieKategorie()
        let szerokoscEkranu = view.bounds.width
        let calkowitaSzerokoscKolumny = CGFloat(kategorie.count) * schematUkladu.szerokoscKafelka + CGFloat(kategorie.count - 1) * schematUkladu.odstepPrzecinajacy
        let startX = (szerokoscEkranu - calkowitaSzerokoscKolumny) / 2
        
        for (indeksKolumny, kafelki) in kategorie.enumerated() {
            let przetasowaneKafelki = kafelki.shuffled()
            var naczyniaKolumny: [NaczynieKafelka] = []
            let kontenerKolumny = utworzWidokKontenera(znacznik: 1000 + indeksKolumny)
            view.addSubview(kontenerKolumny)
            konteneryWierszy.append(kontenerKolumny)
            
            for (indeks, kafelek) in przetasowaneKafelki.enumerated() {
                let naczynie = NaczynieKafelka(element: kafelek, index: indeks)
                kontenerKolumny.addSubview(naczynie)
                naczyniaKolumny.append(naczynie)
                dolaczGestPrzeciagania(do: naczynie)
            }
            
            naczyniaWierszyKafelkow.append(naczyniaKolumny)
            ulozKolumneKafelkow(naczyniaKolumny, w: kontenerKolumny)
            
            NSLayoutConstraint.activate([
                kontenerKolumny.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startX + CGFloat(indeksKolumny) * (schematUkladu.szerokoscKafelka + schematUkladu.odstepPrzecinajacy)),
                kontenerKolumny.topAnchor.constraint(equalTo: view.topAnchor, constant: schematUkladu.przesuniecieGorne),
                kontenerKolumny.widthAnchor.constraint(equalToConstant: schematUkladu.szerokoscKafelka),
                kontenerKolumny.heightAnchor.constraint(equalToConstant: schematUkladu.dlugoscGlowna)
            ])
        }
    }
    
    private func zainicjalizujUkladSiatki() {
        let kafelki = RepozytoriumKafelkow.singleton.pobierzKafelkiDlaKategorii(aktywnaKategoria)
        let przetasowaneKafelki = kafelki.shuffled()
        let kolumny = schematUkladu.kolumny
        let wiersze = schematUkladu.wiersze
        let calkowitaSzerokoscWiersza = schematUkladu.dlugoscGlowna
        let calkowitaWysokosc = schematUkladu.dlugoscDruga
        let szerokoscEkranu = view.bounds.width
        let startX = (szerokoscEkranu - calkowitaSzerokoscWiersza) / 2
        let kontenerSiatki = utworzWidokKontenera(znacznik: 2000)
        view.addSubview(kontenerSiatki)
        konteneryWierszy.append(kontenerSiatki)
        var naczyniaSiatki: [NaczynieKafelka] = []
        for indeks in 0..<(wiersze * kolumny) {
            guard indeks < przetasowaneKafelki.count else { break }
            let kafelek = przetasowaneKafelki[indeks]
            let naczynie = NaczynieKafelka(element: kafelek, index: indeks)
            kontenerSiatki.addSubview(naczynie)
            naczyniaSiatki.append(naczynie)
            dolaczGestPrzeciagania(do: naczynie)
        }
        naczyniaWierszyKafelkow.append(naczyniaSiatki)
        ulozWierszSiatki(naczyniaSiatki, w: kontenerSiatki)
        NSLayoutConstraint.activate([
            kontenerSiatki.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startX),
            kontenerSiatki.topAnchor.constraint(equalTo: view.topAnchor, constant: schematUkladu.przesuniecieGorne),
            kontenerSiatki.widthAnchor.constraint(equalToConstant: calkowitaSzerokoscWiersza),
            kontenerSiatki.heightAnchor.constraint(equalToConstant: calkowitaWysokosc)
        ])
        przechwycZdjecieSiatki()
    }
    
    private func utworzWidokKontenera(znacznik: Int) -> UIView {
        let kontener = UIView()
        kontener.translatesAutoresizingMaskIntoConstraints = false
        kontener.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        kontener.layer.cornerRadius = StaleZywotne.Wymiary.promienZakraglenia
        kontener.layer.borderWidth = 2
        kontener.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        kontener.tag = znacznik
        return kontener
    }
    
    private func dolaczGestPrzeciagania(do naczynie: NaczynieKafelka) {
        let gestPrzeciagania = UIPanGestureRecognizer(target: self, action: #selector(obsluzGestPrzeciagania(_:)))
        naczynie.addGestureRecognizer(gestPrzeciagania)
        naczynie.isUserInteractionEnabled = true
    }
    
    func ulozKolumneKafelkow(_ naczynia: [NaczynieKafelka], w kontener: UIView) {
        for (indeks, naczynie) in naczynia.enumerated() {
            let przesuniecieY = CGFloat(indeks) * (schematUkladu.wysokoscKafelka + schematUkladu.odstepKafelkow)
            
            naczynie.frame = CGRect(
                x: 0,
                y: przesuniecieY,
                width: schematUkladu.szerokoscKafelka,
                height: schematUkladu.wysokoscKafelka
            )
        }
    }
    
    func ulozWierszSiatki(_ naczynia: [NaczynieKafelka], w kontener: UIView) {
        for (indeks, naczynie) in naczynia.enumerated() {
            let kolumna = indeks % schematUkladu.kolumny
            let wiersz = indeks / schematUkladu.kolumny
            let przesuniecieX = CGFloat(kolumna) * (schematUkladu.szerokoscKafelka + schematUkladu.odstepKafelkow)
            let przesuniecieY = CGFloat(wiersz) * (schematUkladu.wysokoscKafelka + schematUkladu.odstepPrzecinajacy)
            naczynie.frame = CGRect(
                x: przesuniecieX,
                y: przesuniecieY,
                width: schematUkladu.szerokoscKafelka,
                height: schematUkladu.wysokoscKafelka
            )
        }
    }
    
    func przestawWiersz(_ indeksWiersza: Int) {
        guard indeksWiersza >= 0 && indeksWiersza < naczyniaWierszyKafelkow.count else { return }
        
        let naczynia = naczyniaWierszyKafelkow[indeksWiersza]
        let kontener = konteneryWierszy[indeksWiersza]
        
        for (indeks, naczynie) in naczynia.enumerated() {
            naczynie.indeksBiezacy = indeks
            
            UIView.animate(
                withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    naczynie.removeFromSuperview()
                    kontener.addSubview(naczynie)
                    if self.wariant.uzywaUkladuSiatki {
                        let przesuniecieX = CGFloat(indeks) * (self.schematUkladu.szerokoscKafelka + self.schematUkladu.odstepKafelkow)
                        naczynie.frame = CGRect(
                            x: przesuniecieX,
                            y: 0,
                            width: self.schematUkladu.szerokoscKafelka,
                            height: self.schematUkladu.wysokoscKafelka
                        )
                    } else {
                        let przesuniecieY = CGFloat(indeks) * (self.schematUkladu.wysokoscKafelka + self.schematUkladu.odstepKafelkow)
                        naczynie.frame = CGRect(
                            x: 0,
                            y: przesuniecieY,
                            width: self.schematUkladu.szerokoscKafelka,
                            height: self.schematUkladu.wysokoscKafelka
                        )
                    }
                }
            )
        }
    }
    
    func przetasujWszystkieWiersze() {
        skrzynkiPrzewijania.removeAll()
        skrzynkaPrzedRuchem = nil
        pozostaleTokenyPrzewijania = wariant.limitPrzewijania
        for indeksWiersza in 0..<naczyniaWierszyKafelkow.count {
            naczyniaWierszyKafelkow[indeksWiersza].shuffle()
            przestawWiersz(indeksWiersza)
        }
        
        czyUjawniono = false
        for wiersz in naczyniaWierszyKafelkow {
            for naczynie in wiersz {
                naczynie.ukryjWartosc()
            }
        }
        zaktualizujEtykieteLimituRuchow()
        zaktualizujStanPrzyciskuPrzewijania()
        zaktualizujTytulPrzelaczaczaKoloru()
    }
    
    func ujawnijWszystkieWartosci() {
        for wiersz in naczyniaWierszyKafelkow {
            for naczynie in wiersz {
                naczynie.ujawnijWartosc()
            }
        }
        czyUjawniono = true
    }
    
    func ukryjWszystkieWartosci() {
        for wiersz in naczyniaWierszyKafelkow {
            for naczynie in wiersz {
                naczynie.ukryjWartosc()
            }
        }
    }
    
    func przelaczWszystkieWartosci() {
        if czyPodpowiedzWidoczna {
            ukryjWszystkieWartosci()
            czyPodpowiedzWidoczna = false
        } else {
            ujawnijWszystkieWartosci()
            czyPodpowiedzWidoczna = true
        }
    }
}

