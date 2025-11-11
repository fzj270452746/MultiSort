//
//  PodrozRekordow+Akcje.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozRekordow {
    
    @objc func wcisnietoPowrot() {
        przyciskPowrotu.animujOdbicie()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: false)  // 禁用动画避免闪烁
        }
    }
    
    @objc func wcisnietoUsuniecie() {
        let alerta = UIAlertController(
            title: "Delete All Records",
            message: "Are you sure you want to delete all game records? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alerta.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.usunWszystkiePamiatki()
        })
        
        present(alerta, animated: true)
    }
    
    func zaladujPamiatki() {
        pamiatki = ArchiwumWynikow.singleton.pobierzPamiatki()
        
        if pamiatki.isEmpty {
            etykietaStanuPustego.isHidden = false
            naczynieTabeli.isHidden = true
            przyciskUsuniecia.isHidden = true
        } else {
            etykietaStanuPustego.isHidden = true
            naczynieTabeli.isHidden = false
            przyciskUsuniecia.isHidden = false
        }
        
        naczynieTabeli.reloadData()
    }
    
    func usunWszystkiePamiatki() {
        ArchiwumWynikow.singleton.usunWszystkiePamiatki()
        zaladujPamiatki()
        
        przyciskUsuniecia.animujPulsowanie()
    }
}

