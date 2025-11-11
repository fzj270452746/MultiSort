//
//  PodrozGry+Wyglad.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozGry {
    
    func skonfigurujWyglad() {
        skonfigurujTlo()
        skonfigurujPrzyciskPowrotu()
        skonfigurujEtykiety()
        skonfigurujTabliceCelow()
        skonfigurujPrzyciski()
    }
    
    func skonfigurujTlo() {
        wizerunekTla.backgroundColor = .black  // 设置背景色避免图片加载前的闪烁
        wizerunekTla.image = UIImage(named: "multiSortImage")
        wizerunekTla.contentMode = .scaleAspectFill
        wizerunekTla.clipsToBounds = true
        
        zaslonaNakladki.backgroundColor = StaleZywotne.Paleta.przyciemnienieNakladki
    }
    
    func skonfigurujPrzyciskPowrotu() {
        let konfiguracja = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let obrazStrzalki = UIImage(systemName: "arrow.left.circle.fill", withConfiguration: konfiguracja)
        przyciskPowrotu.setImage(obrazStrzalki, for: .normal)
        przyciskPowrotu.tintColor = StaleZywotne.Paleta.czystyBialy
        przyciskPowrotu.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        przyciskPowrotu.layer.cornerRadius = 22
        przyciskPowrotu.zastosujDelikatnyCien()
        przyciskPowrotu.addTarget(self, action: #selector(wcisnietoPowrot), for: .touchUpInside)
    }
    
    func skonfigurujEtykiety() {
        etykietaCzasomierza.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        etykietaCzasomierza.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaCzasomierza.text = "\(StaleZywotne.Tekst.czasomierz): 00:00"
        etykietaCzasomierza.zastosujDelikatnyCien()
        
        etykietaWyniku.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        etykietaWyniku.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaWyniku.text = "\(StaleZywotne.Tekst.wynik): 0"
        etykietaWyniku.zastosujDelikatnyCien()
        
        etykietaOdznakiWariantu.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        etykietaOdznakiWariantu.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaOdznakiWariantu.numberOfLines = 2
        etykietaOdznakiWariantu.alpha = 0.9
        etykietaOdznakiWariantu.text = ""
        etykietaOdznakiWariantu.isHidden = true
        
        etykietaLimituRuchow.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        etykietaLimituRuchow.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaLimituRuchow.text = wariant.uzywaUkladuSiatki ? "" : wariant.tytulEtykietyRuchu
        etykietaLimituRuchow.isHidden = wariant.uzywaUkladuSiatki || !wariant.uzywaGornegoUmieszczeniaPodpowiedzi
    }
    
    func skonfigurujTabliceCelow() {
        tablicaCelow.axis = .vertical
        tablicaCelow.alignment = .leading
        tablicaCelow.spacing = 6
        tablicaCelow.isHidden = wariant.sekwencjeCelow.isEmpty || wariant.uzywaUkladuSiatki
        tablicaCelow.arrangedSubviews.forEach { widok in
            tablicaCelow.removeArrangedSubview(widok)
            widok.removeFromSuperview()
        }
        etykietyCelow.removeAll()
        
        guard !wariant.sekwencjeCelow.isEmpty, !wariant.uzywaUkladuSiatki else { return }
        do {
            let etykietaTytulu = UILabel()
            etykietaTytulu.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            etykietaTytulu.textColor = StaleZywotne.Paleta.czystyBialy
            etykietaTytulu.text = "Objective"
            tablicaCelow.addArrangedSubview(etykietaTytulu)
            etykietyCelow.append(etykietaTytulu)
            for (indeks, sekwencja) in wariant.sekwencjeCelow.enumerated() {
                let etykieta = UILabel()
                etykieta.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
                etykieta.textColor = UIColor.white.withAlphaComponent(0.9)
                let tekstSekwencji = sekwencja.map { String($0) }.joined(separator: " → ")
                etykieta.text = "Column \(indeks + 1): \(tekstSekwencji)"
                tablicaCelow.addArrangedSubview(etykieta)
                etykietyCelow.append(etykieta)
            }
        }
    }
    
    func skonfigurujPrzyciski() {
        wstegaPolecen.axis = .horizontal
        wstegaPolecen.spacing = 12
        wstegaPolecen.distribution = .fillEqually
        
        let wspolnePrzyciski = [przyciskPodpowiedzi, przyciskPotwierdzenia, przyciskTasowania, przyciskPrzewijania, przyciskPoddania, przyciskPrzelaczaniaKoloru]
        wspolnePrzyciski.forEach { przycisk in
            przycisk.layer.cornerRadius = StaleZywotne.Wymiary.promienZakraglenia
            przycisk.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            przycisk.setTitleColor(StaleZywotne.Paleta.czystyBialy, for: .normal)
            przycisk.zastosujPromiennyCien()
            przycisk.translatesAutoresizingMaskIntoConstraints = false
            przycisk.heightAnchor.constraint(equalToConstant: StaleZywotne.Wymiary.wysokoscPrzycisku).isActive = false
        }
        
        przyciskPodpowiedzi.setTitle("Hint", for: .normal)
        przyciskPodpowiedzi.backgroundColor = UIColor(red: 0.95, green: 0.55, blue: 0.25, alpha: 1.0)
        przyciskPodpowiedzi.addTarget(self, action: #selector(wcisnietoPodpowiedz(_:)), for: .touchUpInside)
        
        przyciskPotwierdzenia.setTitle(StaleZywotne.Tekst.potwierdzKolejnosc, for: .normal)
        przyciskPotwierdzenia.backgroundColor = StaleZywotne.Paleta.odcienPodstawowy
        przyciskPotwierdzenia.addTarget(self, action: #selector(wcisnietoPotwierdzenie), for: .touchUpInside)
        
        przyciskTasowania.setTitle(StaleZywotne.Tekst.tasuj, for: .normal)
        przyciskTasowania.backgroundColor = StaleZywotne.Paleta.odcienAkcentowy
        przyciskTasowania.addTarget(self, action: #selector(wcisnietoTasowanie), for: .touchUpInside)
        
        przyciskPrzewijania.setTitle("Rewind", for: .normal)
        przyciskPrzewijania.backgroundColor = UIColor(red: 0.36, green: 0.54, blue: 0.96, alpha: 1.0)
        przyciskPrzewijania.addTarget(self, action: #selector(wcisnietoPrzewijanie), for: .touchUpInside)
        
        przyciskPoddania.setTitle("Give Up", for: .normal)
        przyciskPoddania.backgroundColor = UIColor(red: 0.85, green: 0.33, blue: 0.24, alpha: 1.0)
        przyciskPoddania.addTarget(self, action: #selector(wcisnietoPoddanie), for: .touchUpInside)
        
        przyciskPrzelaczaniaKoloru.setTitle("Switch Color", for: .normal)
        przyciskPrzelaczaniaKoloru.backgroundColor = UIColor(red: 0.30, green: 0.70, blue: 0.55, alpha: 1.0)
        przyciskPrzelaczaniaKoloru.addTarget(self, action: #selector(wcisnietoPrzelaczaczKoloru), for: .touchUpInside)
        przyciskPrzelaczaniaKoloru.isHidden = !wariant.uzywaPrzelaczaniaKolorow
        
        wstegaPolecen.arrangedSubviews.forEach { widok in
            wstegaPolecen.removeArrangedSubview(widok)
            widok.removeFromSuperview()
        }
        
        if wariant.uzywaGornegoUmieszczeniaPodpowiedzi {
            if wariant.limitPrzewijania > 0 && !wariant.uzywaUkladuSiatki {
                wstegaPolecen.addArrangedSubview(przyciskPrzewijania)
            }
            wstegaPolecen.addArrangedSubview(przyciskPotwierdzenia)
            wstegaPolecen.addArrangedSubview(przyciskPoddania)
            przyciskPodpowiedzi.layer.cornerRadius = 18
            przyciskPodpowiedzi.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            przyciskPodpowiedzi.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        } else {
            wstegaPolecen.addArrangedSubview(przyciskPodpowiedzi)
            wstegaPolecen.addArrangedSubview(przyciskPotwierdzenia)
            wstegaPolecen.addArrangedSubview(przyciskTasowania)
        }
        
        przyciskPrzewijania.isHidden = !wariant.uzywaGornegoUmieszczeniaPodpowiedzi || wariant.uzywaUkladuSiatki
        przyciskPoddania.isHidden = !wariant.uzywaGornegoUmieszczeniaPodpowiedzi
        przyciskTasowania.isHidden = wariant.uzywaGornegoUmieszczeniaPodpowiedzi
        if wariant.uzywaUkladuSiatki {
            przyciskPrzewijania.alpha = 0.0
            przyciskPrzewijania.isEnabled = false
        }
    }
}

