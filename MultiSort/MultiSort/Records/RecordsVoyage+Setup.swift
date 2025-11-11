//
//  RecordsVoyage+Setup.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension RecordsVoyage {
    
    func assembleHierarchy() {
        view.addSubview(backdropPortrayal)
        view.addSubview(overlayVeil)
        view.addSubview(retreatButton)
        view.addSubview(titleLabel)
        view.addSubview(tableVessel)
        view.addSubview(emptyStateLabel)
        view.addSubview(obliterateButton)
    }
    
    func configureAppearance() {
        configureBackdrop()
        configureRetreatButton()
        configureTitleLabel()
        configureTableVessel()
        configureEmptyStateLabel()
        configureObliterateButton()
    }
    
    func configureBackdrop() {
        backdropPortrayal.image = UIImage(named: "multiSortImage")
        backdropPortrayal.contentMode = .scaleAspectFill
        
        overlayVeil.backgroundColor = VibrantConstants.Palette.overlayDim
    }
    
    func configureRetreatButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let arrowImage = UIImage(systemName: "arrow.left.circle.fill", withConfiguration: configuration)
        retreatButton.setImage(arrowImage, for: .normal)
        retreatButton.tintColor = VibrantConstants.Palette.pureWhite
        retreatButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        retreatButton.layer.cornerRadius = 22
        retreatButton.applySubtleShadow()
        retreatButton.addTarget(self, action: #selector(retreatTapped), for: .touchUpInside)
    }
    
    func configureTitleLabel() {
        titleLabel.text = VibrantConstants.Text.records
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = VibrantConstants.Palette.pureWhite
        titleLabel.textAlignment = .center
        titleLabel.applyRadiantShadow()
    }
    
    func configureTableVessel() {
        tableVessel.delegate = self
        tableVessel.dataSource = self
        tableVessel.backgroundColor = .clear
        tableVessel.separatorStyle = .none
        tableVessel.register(MemorableCell.self, forCellReuseIdentifier: "MemorableCell")
        tableVessel.showsVerticalScrollIndicator = false
    }
    
    func configureEmptyStateLabel() {
        emptyStateLabel.text = VibrantConstants.Text.noRecords
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyStateLabel.textColor = VibrantConstants.Palette.pureWhite
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.isHidden = true
        emptyStateLabel.applySubtleShadow()
    }
    
    func configureObliterateButton() {
        obliterateButton.setTitle(VibrantConstants.Text.deleteAll, for: .normal)
        obliterateButton.backgroundColor = VibrantConstants.Palette.secondaryTint
        obliterateButton.setTitleColor(VibrantConstants.Palette.pureWhite, for: .normal)
        obliterateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        obliterateButton.layer.cornerRadius = VibrantConstants.Measurements.cornerRadius
        obliterateButton.applyRadiantShadow()
        obliterateButton.addTarget(self, action: #selector(obliterateTapped), for: .touchUpInside)
    }
    
    func establishConstraints() {
        backdropPortrayal.translatesAutoresizingMaskIntoConstraints = false
        overlayVeil.translatesAutoresizingMaskIntoConstraints = false
        retreatButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableVessel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        obliterateButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropPortrayal.topAnchor.constraint(equalTo: view.topAnchor),
            backdropPortrayal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropPortrayal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropPortrayal.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayVeil.topAnchor.constraint(equalTo: view.topAnchor),
            overlayVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            retreatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            retreatButton.widthAnchor.constraint(equalToConstant: 44),
            retreatButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableVessel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableVessel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            tableVessel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            tableVessel.bottomAnchor.constraint(equalTo: obliterateButton.topAnchor, constant: -20),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            obliterateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -VibrantConstants.Measurements.padding),
            obliterateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            obliterateButton.widthAnchor.constraint(equalToConstant: 200),
            obliterateButton.heightAnchor.constraint(equalToConstant: VibrantConstants.Measurements.buttonHeight)
        ])
    }
}

