//
//  PodrozInstrukcji+Konfiguracja.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozInstrukcji {
    
    func zlozHierarchie() {
        view.addSubview(wizerunekTla)
        view.addSubview(zaslonaNakladki)
        view.addSubview(przyciskPowrotu)
        view.addSubview(etykietaTytulu)
        view.addSubview(naczyniePrzewijania)
        naczyniePrzewijania.addSubview(kontenerZawartosci)
        kontenerZawartosci.addSubview(tekstInstrukcji)
    }
    
    func skonfigurujWyglad() {
        skonfigurujTlo()
        skonfigurujPrzyciskPowrotu()
        skonfigurujEtykieteTytulu()
        skonfigurujNaczyniePrzewijania()
        skonfigurujTekstInstrukcji()
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
        etykietaTytulu.text = StaleZywotne.Tekst.tytulInstrukcji
        etykietaTytulu.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        etykietaTytulu.textColor = StaleZywotne.Paleta.czystyBialy
        etykietaTytulu.textAlignment = .center
        etykietaTytulu.zastosujPromiennyCien()
    }
    
    func skonfigurujNaczyniePrzewijania() {
        naczyniePrzewijania.showsVerticalScrollIndicator = false
    }
    
    func skonfigurujTekstInstrukcji() {
        tekstInstrukcji.text = StaleZywotne.Tekst.trescInstrukcji
        tekstInstrukcji.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tekstInstrukcji.textColor = StaleZywotne.Paleta.czystyBialy
        tekstInstrukcji.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        tekstInstrukcji.layer.cornerRadius = StaleZywotne.Wymiary.promienZakraglenia
        tekstInstrukcji.isEditable = false
        tekstInstrukcji.isSelectable = false
        tekstInstrukcji.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        tekstInstrukcji.zastosujDelikatnyCien()
    }
    
    func ustanowOgraniczenia() {
        wizerunekTla.translatesAutoresizingMaskIntoConstraints = false
        zaslonaNakladki.translatesAutoresizingMaskIntoConstraints = false
        przyciskPowrotu.translatesAutoresizingMaskIntoConstraints = false
        etykietaTytulu.translatesAutoresizingMaskIntoConstraints = false
        naczyniePrzewijania.translatesAutoresizingMaskIntoConstraints = false
        kontenerZawartosci.translatesAutoresizingMaskIntoConstraints = false
        tekstInstrukcji.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            naczyniePrzewijania.topAnchor.constraint(equalTo: etykietaTytulu.bottomAnchor, constant: 30),
            naczyniePrzewijania.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            naczyniePrzewijania.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            naczyniePrzewijania.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            kontenerZawartosci.topAnchor.constraint(equalTo: naczyniePrzewijania.topAnchor),
            kontenerZawartosci.leadingAnchor.constraint(equalTo: naczyniePrzewijania.leadingAnchor),
            kontenerZawartosci.trailingAnchor.constraint(equalTo: naczyniePrzewijania.trailingAnchor),
            kontenerZawartosci.bottomAnchor.constraint(equalTo: naczyniePrzewijania.bottomAnchor),
            kontenerZawartosci.widthAnchor.constraint(equalTo: naczyniePrzewijania.widthAnchor),
            
            tekstInstrukcji.topAnchor.constraint(equalTo: kontenerZawartosci.topAnchor),
            tekstInstrukcji.leadingAnchor.constraint(equalTo: kontenerZawartosci.leadingAnchor, constant: StaleZywotne.Wymiary.wciecie),
            tekstInstrukcji.trailingAnchor.constraint(equalTo: kontenerZawartosci.trailingAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            tekstInstrukcji.bottomAnchor.constraint(equalTo: kontenerZawartosci.bottomAnchor, constant: -StaleZywotne.Wymiary.wciecie),
            tekstInstrukcji.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        ])
    }
    
    @objc func wcisnietoPowrot() {
        przyciskPowrotu.animujOdbicie()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: false)  // 禁用动画避免闪烁
        }
    }
}

