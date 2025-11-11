//
//  PodrozRekordow+Tabela.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension PodrozRekordow: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tabela: UITableView, numberOfRowsInSection sekcja: Int) -> Int {
        return pamiatki.count
    }
    
    func tableView(_ tabela: UITableView, cellForRowAt indeksSciezki: IndexPath) -> UITableViewCell {
        guard let komorka = tabela.dequeueReusableCell(withIdentifier: "KomorkaPamiatki", for: indeksSciezki) as? KomorkaPamiatki else {
            return UITableViewCell()
        }
        
        let pamiatka = pamiatki[indeksSciezki.row]
        komorka.skonfigurujZPamiatka(pamiatka, pozycja: indeksSciezki.row + 1)
        return komorka
    }
    
    func tableView(_ tabela: UITableView, heightForRowAt indeksSciezki: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tabela: UITableView, didSelectRowAt indeksSciezki: IndexPath) {
        tabela.deselectRow(at: indeksSciezki, animated: true)
    }
}

class KomorkaPamiatki: UITableViewCell {
    
    let widokKontenera = UIView()
    let etykietaPozycji = UILabel()
    let etykietaWyniku = UILabel()
    let etykietaWariantu = UILabel()
    let etykietaCzasu = UILabel()
    let etykietaDaty = UILabel()
    let odznakaIdealna = UILabel()
    let etykietaSzczegolow = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        zlozKomorke()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func zlozKomorke() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(widokKontenera)
        widokKontenera.addSubview(etykietaPozycji)
        widokKontenera.addSubview(etykietaWyniku)
        widokKontenera.addSubview(etykietaWariantu)
        widokKontenera.addSubview(etykietaCzasu)
        widokKontenera.addSubview(etykietaSzczegolow)
        widokKontenera.addSubview(etykietaDaty)
        widokKontenera.addSubview(odznakaIdealna)
        
        widokKontenera.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        widokKontenera.layer.cornerRadius = StaleZywotne.Wymiary.promienZakraglenia
        widokKontenera.zastosujDelikatnyCien()
        
        etykietaPozycji.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        etykietaPozycji.textColor = StaleZywotne.Paleta.odcienPodstawowy
        
        etykietaWyniku.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        etykietaWyniku.textColor = StaleZywotne.Paleta.czystyBialy
        
        etykietaWariantu.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        etykietaWariantu.textColor = UIColor.white.withAlphaComponent(0.9)
        
        etykietaCzasu.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        etykietaCzasu.textColor = StaleZywotne.Paleta.czystyBialy
        
        etykietaSzczegolow.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        etykietaSzczegolow.textColor = UIColor.white.withAlphaComponent(0.85)
        
        etykietaDaty.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        etykietaDaty.textColor = UIColor.white.withAlphaComponent(0.8)
        
        odznakaIdealna.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        odznakaIdealna.textColor = StaleZywotne.Paleta.czystyBialy
        odznakaIdealna.backgroundColor = StaleZywotne.Paleta.odcienPodstawowy
        odznakaIdealna.text = "★ IDEALNE"
        odznakaIdealna.textAlignment = .center
        odznakaIdealna.layer.cornerRadius = 10
        odznakaIdealna.layer.masksToBounds = true
        odznakaIdealna.isHidden = true
        
        widokKontenera.translatesAutoresizingMaskIntoConstraints = false
        etykietaPozycji.translatesAutoresizingMaskIntoConstraints = false
        etykietaWyniku.translatesAutoresizingMaskIntoConstraints = false
        etykietaWariantu.translatesAutoresizingMaskIntoConstraints = false
        etykietaCzasu.translatesAutoresizingMaskIntoConstraints = false
        etykietaSzczegolow.translatesAutoresizingMaskIntoConstraints = false
        etykietaDaty.translatesAutoresizingMaskIntoConstraints = false
        odznakaIdealna.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widokKontenera.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            widokKontenera.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            widokKontenera.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            widokKontenera.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            etykietaPozycji.leadingAnchor.constraint(equalTo: widokKontenera.leadingAnchor, constant: 16),
            etykietaPozycji.centerYAnchor.constraint(equalTo: widokKontenera.centerYAnchor),
            etykietaPozycji.widthAnchor.constraint(equalToConstant: 50),
            
            etykietaWyniku.topAnchor.constraint(equalTo: widokKontenera.topAnchor, constant: 12),
            etykietaWyniku.leadingAnchor.constraint(equalTo: etykietaPozycji.trailingAnchor, constant: 12),
            
            etykietaWariantu.topAnchor.constraint(equalTo: etykietaWyniku.bottomAnchor, constant: 4),
            etykietaWariantu.leadingAnchor.constraint(equalTo: etykietaPozycji.trailingAnchor, constant: 12),
            etykietaWariantu.trailingAnchor.constraint(lessThanOrEqualTo: odznakaIdealna.leadingAnchor, constant: -12),
            
            etykietaCzasu.topAnchor.constraint(equalTo: etykietaWariantu.bottomAnchor, constant: 4),
            etykietaCzasu.leadingAnchor.constraint(equalTo: etykietaPozycji.trailingAnchor, constant: 12),
            
            etykietaSzczegolow.topAnchor.constraint(equalTo: etykietaCzasu.bottomAnchor, constant: 4),
            etykietaSzczegolow.leadingAnchor.constraint(equalTo: etykietaPozycji.trailingAnchor, constant: 12),
            
            etykietaDaty.topAnchor.constraint(equalTo: etykietaSzczegolow.bottomAnchor, constant: 4),
            etykietaDaty.leadingAnchor.constraint(equalTo: etykietaPozycji.trailingAnchor, constant: 12),
            
            odznakaIdealna.trailingAnchor.constraint(equalTo: widokKontenera.trailingAnchor, constant: -16),
            odznakaIdealna.centerYAnchor.constraint(equalTo: widokKontenera.centerYAnchor),
            odznakaIdealna.widthAnchor.constraint(equalToConstant: 90),
            odznakaIdealna.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func skonfigurujZPamiatka(_ pamiatka: PamiatkaGry, pozycja: Int) {
        etykietaPozycji.text = "\(pozycja)"
        etykietaWyniku.text = "Score: \(pamiatka.osiagnietyWynik)"
        etykietaWariantu.text = pamiatka.nazwaWyswietlanaWariantu
        etykietaCzasu.text = "Time: \(pamiatka.sformatowanyCzasTrwania)"
        if let ruchy = pamiatka.sladRuchu {
            let tekstPrzewijania = (pamiatka.uzytoPrzewijania ?? false) ? "Rewind used" : "No rewind used"
            if let rezydualny = pamiatka.sformatowanyCzasRezydualny {
                etykietaSzczegolow.text = "Moves: \(ruchy) • Remaining time: \(rezydualny) • \(tekstPrzewijania)"
            } else {
                etykietaSzczegolow.text = "Moves: \(ruchy) • \(tekstPrzewijania)"
            }
        } else if let rezydualny = pamiatka.sformatowanyCzasRezydualny {
            etykietaSzczegolow.text = "Remaining time: \(rezydualny)"
        } else {
            etykietaSzczegolow.text = ""
        }
        etykietaSzczegolow.isHidden = (etykietaSzczegolow.text ?? "").isEmpty
        etykietaDaty.text = pamiatka.sformatowanaData
        odznakaIdealna.isHidden = !pamiatka.byloIdealne
    }
}

