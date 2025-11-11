//
//  PodrozGry+Hierarchia.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozGry {
    
    func zlozHierarchie() {
        view.addSubview(wizerunekTla)
        view.addSubview(zaslonaNakladki)
        view.addSubview(przyciskPowrotu)
        view.addSubview(etykietaCzasomierza)
        view.addSubview(etykietaWyniku)
        view.addSubview(etykietaOdznakiWariantu)
        view.addSubview(tablicaCelow)
        view.addSubview(etykietaLimituRuchow)
        if wariant.uzywaPrzelaczaniaKolorow {
            view.addSubview(przyciskPrzelaczaniaKoloru)
        }
        view.addSubview(przyciskPodpowiedzi)
        view.addSubview(wstegaPolecen)
    }
    
    func ustanowOgraniczenia() {
        wizerunekTla.translatesAutoresizingMaskIntoConstraints = false
        zaslonaNakladki.translatesAutoresizingMaskIntoConstraints = false
        przyciskPowrotu.translatesAutoresizingMaskIntoConstraints = false
        etykietaCzasomierza.translatesAutoresizingMaskIntoConstraints = false
        etykietaWyniku.translatesAutoresizingMaskIntoConstraints = false
        przyciskPodpowiedzi.translatesAutoresizingMaskIntoConstraints = false
        etykietaOdznakiWariantu.translatesAutoresizingMaskIntoConstraints = false
        tablicaCelow.translatesAutoresizingMaskIntoConstraints = false
        etykietaLimituRuchow.translatesAutoresizingMaskIntoConstraints = false
        wstegaPolecen.translatesAutoresizingMaskIntoConstraints = false
        if wariant.uzywaPrzelaczaniaKolorow {
            przyciskPrzelaczaniaKoloru.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            wizerunekTla.topAnchor.constraint(equalTo: view.topAnchor),
            wizerunekTla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wizerunekTla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wizerunekTla.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            zaslonaNakladki.topAnchor.constraint(equalTo: view.topAnchor),
            zaslonaNakladki.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zaslonaNakladki.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zaslonaNakladki.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            przyciskPowrotu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            przyciskPowrotu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StaleZywotne.Wymiary.wciecie),
            przyciskPowrotu.widthAnchor.constraint(equalToConstant: 44),
            przyciskPowrotu.heightAnchor.constraint(equalToConstant: 44),
            
            etykietaCzasomierza.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            etykietaCzasomierza.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            
            etykietaWyniku.topAnchor.constraint(equalTo: etykietaCzasomierza.bottomAnchor, constant: 8),
            etykietaWyniku.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            
            etykietaOdznakiWariantu.leadingAnchor.constraint(equalTo: przyciskPowrotu.trailingAnchor, constant: 12),
            etykietaOdznakiWariantu.trailingAnchor.constraint(lessThanOrEqualTo: etykietaCzasomierza.leadingAnchor, constant: -12),
            etykietaOdznakiWariantu.topAnchor.constraint(equalTo: przyciskPowrotu.topAnchor),
            
            tablicaCelow.topAnchor.constraint(equalTo: etykietaOdznakiWariantu.bottomAnchor, constant: 8),
            tablicaCelow.leadingAnchor.constraint(equalTo: etykietaOdznakiWariantu.leadingAnchor),
            tablicaCelow.trailingAnchor.constraint(lessThanOrEqualTo: etykietaCzasomierza.leadingAnchor, constant: -12),
            
            etykietaLimituRuchow.topAnchor.constraint(equalTo: tablicaCelow.bottomAnchor, constant: 8),
            etykietaLimituRuchow.leadingAnchor.constraint(equalTo: etykietaOdznakiWariantu.leadingAnchor),
            etykietaLimituRuchow.trailingAnchor.constraint(lessThanOrEqualTo: etykietaCzasomierza.leadingAnchor, constant: -12),
            
            wstegaPolecen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StaleZywotne.Wymiary.wciecie),
            wstegaPolecen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            wstegaPolecen.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            wstegaPolecen.heightAnchor.constraint(equalToConstant: StaleZywotne.Wymiary.wysokoscPrzycisku)
        ])
        
        if wariant.uzywaGornegoUmieszczeniaPodpowiedzi {
            ograniczeniaPodpowiedziSwiadomej = [
                przyciskPodpowiedzi.topAnchor.constraint(equalTo: etykietaWyniku.bottomAnchor, constant: 12),
                przyciskPodpowiedzi.trailingAnchor.constraint(equalTo: etykietaWyniku.trailingAnchor),
                przyciskPodpowiedzi.widthAnchor.constraint(equalToConstant: 120),
                przyciskPodpowiedzi.heightAnchor.constraint(equalToConstant: StaleZywotne.Wymiary.wysokoscPrzycisku * 0.8)
            ]
            NSLayoutConstraint.activate(ograniczeniaPodpowiedziSwiadomej)
        }
        
        if wariant.uzywaPrzelaczaniaKolorow {
            ograniczeniaPrzelaczaczaKoloru = [
                przyciskPrzelaczaniaKoloru.centerYAnchor.constraint(equalTo: przyciskPodpowiedzi.centerYAnchor),
                przyciskPrzelaczaniaKoloru.leadingAnchor.constraint(equalTo: przyciskPowrotu.leadingAnchor),
                przyciskPrzelaczaniaKoloru.trailingAnchor.constraint(equalTo: przyciskPodpowiedzi.leadingAnchor, constant: -12),
                przyciskPrzelaczaniaKoloru.heightAnchor.constraint(equalTo: przyciskPodpowiedzi.heightAnchor)
            ]
            NSLayoutConstraint.activate(ograniczeniaPrzelaczaczaKoloru)
        }
    }
}

