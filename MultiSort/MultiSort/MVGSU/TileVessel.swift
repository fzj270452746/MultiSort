
import UIKit

class NaczynieKafelka: UIView {
    
    let wizerunek: UIImageView = {
        let widokObrazu = UIImageView()
        widokObrazu.contentMode = .scaleAspectFill
        widokObrazu.translatesAutoresizingMaskIntoConstraints = false
        widokObrazu.layer.cornerRadius = 3
        widokObrazu.layer.masksToBounds = true
        return widokObrazu
    }()
    
    let etykietaWartosci: UILabel = {
        let etykieta = UILabel()
        let wysokoscKafelka = StaleZywotne.Wymiary.wysokoscKafelka
        let bokEtykiety = max(28, wysokoscKafelka * 0.65)
        let rozmiarCzcionki: CGFloat = max(18, bokEtykiety * 0.55)
        etykieta.font = UIFont.systemFont(ofSize: rozmiarCzcionki, weight: .black)
        etykieta.textColor = StaleZywotne.Paleta.odcienDrugorzedny
        etykieta.textAlignment = .center
        etykieta.isHidden = true
        etykieta.translatesAutoresizingMaskIntoConstraints = false
        etykieta.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        etykieta.layer.cornerRadius = bokEtykiety / 2
        etykieta.layer.masksToBounds = true
        etykieta.layer.borderWidth = 2
        etykieta.layer.borderColor = StaleZywotne.Paleta.odcienDrugorzedny.cgColor
        return etykieta
    }()
    
    let element: ElementKafelka
    var indeksPoczatkowy: Int
    var indeksBiezacy: Int
    
    init(element: ElementKafelka, index: Int) {
        self.element = element
        self.indeksPoczatkowy = index
        self.indeksBiezacy = index
        super.init(frame: .zero)
        
        zlozWidok()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func zlozWidok() {
        backgroundColor = .clear
        layer.cornerRadius = 3
        layer.masksToBounds = false
        zastosujDelikatnyCien()
        
        addSubview(wizerunek)
        addSubview(etykietaWartosci)
        
        NSLayoutConstraint.activate([
            wizerunek.topAnchor.constraint(equalTo: topAnchor),
            wizerunek.leadingAnchor.constraint(equalTo: leadingAnchor),
            wizerunek.trailingAnchor.constraint(equalTo: trailingAnchor),
            wizerunek.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            etykietaWartosci.centerXAnchor.constraint(equalTo: centerXAnchor),
            etykietaWartosci.centerYAnchor.constraint(equalTo: centerYAnchor),
            etykietaWartosci.widthAnchor.constraint(equalToConstant: max(28, StaleZywotne.Wymiary.wysokoscKafelka * 0.65)),
            etykietaWartosci.heightAnchor.constraint(equalToConstant: max(28, StaleZywotne.Wymiary.wysokoscKafelka * 0.65))
        ])
        
        wizerunek.image = element.wizerunek
    }
    
    func ujawnijWartosc() {
        etykietaWartosci.text = "\(element.wartosc)"
        
        UIView.animate(withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy) {
            self.etykietaWartosci.isHidden = false
            self.etykietaWartosci.alpha = 1.0
        }
    }
    
    func ukryjWartosc() {
        UIView.animate(withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy) {
            self.etykietaWartosci.alpha = 0
        } completion: { _ in
            self.etykietaWartosci.isHidden = true
        }
    }
}
