//
//  PodrozRekordow+Konfiguracja.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozRekordow {
    
    func zlozHierarchie() {
        view.addSubview(wizerunekTla)
        view.addSubview(zaslonaNakladki)
        view.addSubview(przyciskPowrotu)
        view.addSubview(etykietaTytulu)
        view.addSubview(naczynieTabeli)
        view.addSubview(etykietaStanuPustego)
        view.addSubview(przyciskUsuniecia)
    }
    
    func skonfigurujWyglad() {
        skonfigurujTlo()
        skonfigurujPrzyciskPowrotu()
        skonfigurujEtykieteTytulu()
        skonfigurujNaczynieTabeli()
        skonfigurujEtykieteStanuPustego()
        skonfigurujPrzyciskUsuniecia()
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
    
    func skonfigurujEtykieteTytulu() {
        etykietaTytulu.text = StaleZywotne.Tekst.rekordy
        etykietaTytulu.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        etykietaTytulu.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaTytulu.textAlignment = .center
        etykietaTytulu.zastosujPromiennyCien()
    }
    
    func skonfigurujNaczynieTabeli() {
        naczynieTabeli.delegate = self
        naczynieTabeli.dataSource = self
        naczynieTabeli.backgroundColor = .clear
        naczynieTabeli.separatorStyle = .none
        naczynieTabeli.register(KomorkaPamiatki.self, forCellReuseIdentifier: "KomorkaPamiatki")
        naczynieTabeli.showsVerticalScrollIndicator = false
    }
    
    func skonfigurujEtykieteStanuPustego() {
        etykietaStanuPustego.text = StaleZywotne.Tekst.brakRekordow
        etykietaStanuPustego.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        etykietaStanuPustego.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaStanuPustego.textAlignment = .center
        etykietaStanuPustego.numberOfLines = 0
        etykietaStanuPustego.isHidden = true
        etykietaStanuPustego.zastosujDelikatnyCien()
    }
    
    func skonfigurujPrzyciskUsuniecia() {
        przyciskUsuniecia.setTitle(StaleZywotne.Tekst.usunWszystko, for: .normal)
        przyciskUsuniecia.backgroundColor = StaleZywotne.Paleta.odcienDrugorzedny
        przyciskUsuniecia.setTitleColor(StaleZywotne.Paleta.czystyBialy, for: .normal)
        przyciskUsuniecia.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        przyciskUsuniecia.layer.cornerRadius = StaleZywotne.Wymiary.promienZakraglenia
        przyciskUsuniecia.zastosujPromiennyCien()
        przyciskUsuniecia.addTarget(self, action: #selector(wcisnietoUsuniecie), for: .touchUpInside)
    }
    
    func ustanowOgraniczenia() {
        wizerunekTla.translatesAutoresizingMaskIntoConstraints = false
        zaslonaNakladki.translatesAutoresizingMaskIntoConstraints = false
        przyciskPowrotu.translatesAutoresizingMaskIntoConstraints = false
        etykietaTytulu.translatesAutoresizingMaskIntoConstraints = false
        naczynieTabeli.translatesAutoresizingMaskIntoConstraints = false
        etykietaStanuPustego.translatesAutoresizingMaskIntoConstraints = false
        przyciskUsuniecia.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            etykietaTytulu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            etykietaTytulu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            naczynieTabeli.topAnchor.constraint(equalTo: etykietaTytulu.bottomAnchor, constant: 30),
            naczynieTabeli.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StaleZywotne.Wymiary.wciecie),
            naczynieTabeli.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            naczynieTabeli.bottomAnchor.constraint(equalTo: przyciskUsuniecia.topAnchor, constant: -20),
            
            etykietaStanuPustego.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            etykietaStanuPustego.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            etykietaStanuPustego.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            etykietaStanuPustego.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            przyciskUsuniecia.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            przyciskUsuniecia.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            przyciskUsuniecia.widthAnchor.constraint(equalToConstant: 200),
            przyciskUsuniecia.heightAnchor.constraint(equalToConstant: StaleZywotne.Wymiary.wysokoscPrzycisku)
        ])
    }
}

