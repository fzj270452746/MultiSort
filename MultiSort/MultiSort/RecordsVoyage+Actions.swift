//
//  RecordsVoyage+Actions.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension RecordsVoyage {
    
    @objc override func retreatTapped() {
        retreatButton.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func obliterateTapped() {
        let alert = UIAlertController(
            title: "Delete All Records",
            message: "Are you sure you want to delete all game records? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.obliterateAllMemorables()
        })
        
        present(alert, animated: true)
    }
    
    func loadMemorables() {
        memorables = ScoreArchive.singleton.retrieveMemorables()
        
        if memorables.isEmpty {
            emptyStateLabel.isHidden = false
            tableVessel.isHidden = true
            obliterateButton.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            tableVessel.isHidden = false
            obliterateButton.isHidden = false
        }
        
        tableVessel.reloadData()
    }
    
    func obliterateAllMemorables() {
        ScoreArchive.singleton.obliterateAllMemorables()
        loadMemorables()
        
        obliterateButton.animatePulse()
    }
}

