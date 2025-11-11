//
//  PodrozGry.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class PodrozGry: UIViewController {
    
    let wariant: WariantGry
    
    let wizerunekTla = UIImageView()
    let zaslonaNakladki = UIView()
    let przyciskPowrotu = UIButton(type: .system)
    let etykietaCzasomierza = UILabel()
    let etykietaWyniku = UILabel()
    let przyciskPotwierdzenia = UIButton(type: .system)
    let przyciskTasowania = UIButton(type: .system)
    let przyciskPodpowiedzi = UIButton(type: .system)
    let przyciskPrzewijania = UIButton(type: .system)
    let przyciskPoddania = UIButton(type: .system)
    let przyciskPrzelaczaniaKoloru = UIButton(type: .system)
    let etykietaOdznakiWariantu = UILabel()
    let etykietaLimituRuchow = UILabel()
    let tablicaCelow = UIStackView()
    let wstegaPolecen = UIStackView()
    
    var etykietyCelow: [UILabel] = []
    var ograniczeniaPodpowiedziSwiadomej: [NSLayoutConstraint] = []
    
    var naczyniaWierszyKafelkow: [[NaczynieKafelka]] = []
    var konteneryWierszy: [UIView] = []
    var schematUkladu = SchematUkladu(
        szerokoscKafelka: 45,
        wysokoscKafelka: 55,
        odstepKafelkow: 4,
        odstepPrzecinajacy: 20,
        dlugoscGlowna: 527,
        dlugoscDruga: 45,
        przesuniecieGorne: 100,
        wiersze: 9,
        kolumny: 3,
        osRuchu: .vertical
    )
    
    var czasomierz: Timer?
    var uplywajaceSekundy: Int = 0
    var osiagnietyWynik: Int = 0
    var pozostaleSekundy: Int = 0
    var pozostaleRuchy: Int = 0
    var pozostaleTokenyPrzewijania: Int = 0
    var skrzynkiPrzewijania: [SkrzynkaPrzewijania] = []
    var skrzynkaPrzedRuchem: SkrzynkaPrzewijania?
    var sekwencjeCelow: [[Int]] = []
    var ograniczeniaPrzelaczaczaKoloru: [NSLayoutConstraint] = []
    var aktywnyIndeksKoloru: Int = 0
    let dostepneKategorie = ElementKafelka.KategoriaKafelka.allCases
    
    var przeciaganeNaczynie: NaczynieKafelka?
    var poczatkowySrodekPrzeciagania: CGPoint = .zero
    var indeksPrzeciaganegoWiersza: Int = -1
    
    var czyUjawniono: Bool = false
    var czyPokazanoInstrukcje: Bool = false
    var czyPodpowiedzWidoczna: Bool = false
    
    init(wariant: WariantGry = .klasycznyPrzeplyw) {
        self.wariant = wariant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black  // 设置背景色避免白色闪烁

        skonfigurujStanWariantu()
        zlozHierarchie()
        skonfigurujWyglad()
        ustanowOgraniczenia()
        zainicjalizujWierszeKafelkow()
        rozpoczniCzasomierz()
        zaktualizujWyswietlanieWyniku()
        zaktualizujEtykieteLimituRuchow()
        zaktualizujStanPrzyciskuPrzewijania()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)  // 使用 false 避免闪烁
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !czyPokazanoInstrukcje {
            czyPokazanoInstrukcje = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.wyswietlInstrukcjePrzeciagania()
            }
        }
    }
    
    deinit {
        czasomierz?.invalidate()
    }
    
    var aktywnaKategoria: ElementKafelka.KategoriaKafelka {
        guard wariant.uzywaPrzelaczaniaKolorow else { return dostepneKategorie.first ?? .kola }
        let indeks = (aktywnyIndeksKoloru % max(dostepneKategorie.count, 1) + max(dostepneKategorie.count, 1)) % max(dostepneKategorie.count, 1)
        return dostepneKategorie[indeks]
    }
}

