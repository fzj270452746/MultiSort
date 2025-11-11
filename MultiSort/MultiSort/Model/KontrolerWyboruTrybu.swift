
import UIKit

class KontrolerWyboruTrybu: UIViewController {
    var wybrano: ((WariantGry) -> Void)?
    var anulowano: (() -> Void)?
    
    private let widokRozmycia = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let widokKarty = UIView()
    private let etykietaTytulu = UILabel()
    private let etykietaPodtytulu = UILabel()
    private let stosOpcji = UIStackView()
    private let przyciskAnulowania = UIButton(type: .system)
    private var warstwaGradientu: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skonfigurujPodstawowyWyglad()
        zlozHierarchie()
        skonfigurujZawartosc()
        ulozZawartosc()
        animujWejscie()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        warstwaGradientu?.frame = widokKarty.bounds
    }
    
    private func skonfigurujPodstawowyWyglad() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        widokRozmycia.translatesAutoresizingMaskIntoConstraints = false
        widokRozmycia.alpha = 0
        view.addSubview(widokRozmycia)
        NSLayoutConstraint.activate([
            widokRozmycia.topAnchor.constraint(equalTo: view.topAnchor),
            widokRozmycia.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            widokRozmycia.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            widokRozmycia.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let gestDotkniecia = UITapGestureRecognizer(target: self, action: #selector(wcisnietoAnulowanie))
        widokRozmycia.addGestureRecognizer(gestDotkniecia)
    }
    
    private func zlozHierarchie() {
        widokKarty.translatesAutoresizingMaskIntoConstraints = false
        widokKarty.layer.cornerRadius = 24
        widokKarty.layer.masksToBounds = true
        widokKarty.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        warstwaGradientu = utworzWarstweGradientu()
        if let warstwaGradientu {
            widokKarty.layer.insertSublayer(warstwaGradientu, at: 0)
        }
        view.addSubview(widokKarty)
        
        etykietaTytulu.translatesAutoresizingMaskIntoConstraints = false
        etykietaPodtytulu.translatesAutoresizingMaskIntoConstraints = false
        stosOpcji.translatesAutoresizingMaskIntoConstraints = false
        przyciskAnulowania.translatesAutoresizingMaskIntoConstraints = false
        widokKarty.addSubview(etykietaTytulu)
        widokKarty.addSubview(etykietaPodtytulu)
        widokKarty.addSubview(stosOpcji)
        widokKarty.addSubview(przyciskAnulowania)
    }
    
    private func skonfigurujZawartosc() {
        etykietaTytulu.text = "Choose Game Mode"
        etykietaTytulu.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        etykietaTytulu.textColor = .white
        
        etykietaPodtytulu.text = "Choose a tile sorting method."
        etykietaPodtytulu.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        etykietaPodtytulu.textColor = UIColor.white.withAlphaComponent(0.85)
        etykietaPodtytulu.numberOfLines = 0
        
        stosOpcji.axis = .vertical
        stosOpcji.spacing = 14
        stosOpcji.alignment = .fill
        
        for (indeks, wariant) in WariantGry.allCases.enumerated() {
            let przyciskOpcji = utworzPrzyciskOpcji(dla: wariant)
            przyciskOpcji.tag = indeks
            stosOpcji.addArrangedSubview(przyciskOpcji)
        }
        
        przyciskAnulowania.setTitle("Maybe Later", for: .normal)
        przyciskAnulowania.setTitleColor(.white, for: .normal)
        przyciskAnulowania.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        przyciskAnulowania.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        przyciskAnulowania.layer.cornerRadius = 16
        przyciskAnulowania.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        przyciskAnulowania.addTarget(self, action: #selector(wcisnietoAnulowanie), for: .touchUpInside)
    }
    
    private func ulozZawartosc() {
        let odstepBocznyKarty: CGFloat = 28
        NSLayoutConstraint.activate([
            widokKarty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            widokKarty.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: odstepBocznyKarty),
            widokKarty.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -odstepBocznyKarty)
        ])
        
        NSLayoutConstraint.activate([
            etykietaTytulu.topAnchor.constraint(equalTo: widokKarty.topAnchor, constant: 28),
            etykietaTytulu.leadingAnchor.constraint(equalTo: widokKarty.leadingAnchor, constant: 24),
            etykietaTytulu.trailingAnchor.constraint(equalTo: widokKarty.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            etykietaPodtytulu.topAnchor.constraint(equalTo: etykietaTytulu.bottomAnchor, constant: 8),
            etykietaPodtytulu.leadingAnchor.constraint(equalTo: widokKarty.leadingAnchor, constant: 24),
            etykietaPodtytulu.trailingAnchor.constraint(equalTo: widokKarty.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            stosOpcji.topAnchor.constraint(equalTo: etykietaPodtytulu.bottomAnchor, constant: 20),
            stosOpcji.leadingAnchor.constraint(equalTo: widokKarty.leadingAnchor, constant: 20),
            stosOpcji.trailingAnchor.constraint(equalTo: widokKarty.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            przyciskAnulowania.topAnchor.constraint(equalTo: stosOpcji.bottomAnchor, constant: 24),
            przyciskAnulowania.centerXAnchor.constraint(equalTo: widokKarty.centerXAnchor),
            przyciskAnulowania.bottomAnchor.constraint(equalTo: widokKarty.bottomAnchor, constant: -24)
        ])
    }
    
    private func utworzPrzyciskOpcji(dla wariant: WariantGry) -> UIButton {
        let przycisk = UIButton(type: .system)
        przycisk.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        przycisk.layer.cornerRadius = 18
        przycisk.layer.borderWidth = 1
        przycisk.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        przycisk.contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        przycisk.setTitleColor(.white, for: .normal)
        przycisk.titleLabel?.numberOfLines = 0
        przycisk.titleLabel?.textAlignment = .left
        przycisk.addTarget(self, action: #selector(wcisnietoPrzyciskTrybu(_:)), for: .touchUpInside)
        przycisk.addTarget(self, action: #selector(przyciskTrybuDotknietyWDol(_:)), for: .touchDown)
        przycisk.addTarget(self, action: #selector(przyciskTrybuDotknietyWGore(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        let tytul = NSMutableAttributedString(
            string: "\(wariant.nazwaWyswietlana)\n",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
            ]
        )
        let szczegoly = NSAttributedString(
            string: wariant.opisowyTekst,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.75),
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
        tytul.append(szczegoly)
        przycisk.setAttributedTitle(tytul, for: .normal)
        
        return przycisk
    }
    
    private func utworzWarstweGradientu() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.17, green: 0.20, blue: 0.36, alpha: 0.9).cgColor,
            UIColor(red: 0.10, green: 0.14, blue: 0.25, alpha: 0.95).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    private func animujWejscie() {
        widokKarty.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        widokKarty.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.widokRozmycia.alpha = 1
            self.widokKarty.alpha = 1
            self.widokKarty.transform = .identity
        }
    }
    
    private func animujWyjscie(ukonczenie: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
            self.widokRozmycia.alpha = 0
            self.widokKarty.alpha = 0
            self.widokKarty.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            ukonczenie?()
        }
    }
    
    @objc private func wcisnietoPrzyciskTrybu(_ nadawca: UIButton) {
        let indeks = nadawca.tag
        guard indeks >= 0 && indeks < WariantGry.allCases.count else { return }
        let wariant = WariantGry.allCases[indeks]
        animujWyjscie { [weak self] in
            self?.dismiss(animated: false) {
                self?.wybrano?(wariant)
            }
        }
    }
    
    @objc private func przyciskTrybuDotknietyWDol(_ nadawca: UIButton) {
        UIView.animate(withDuration: 0.15) {
            nadawca.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            nadawca.backgroundColor = UIColor.white.withAlphaComponent(0.22)
        }
    }
    
    @objc private func przyciskTrybuDotknietyWGore(_ nadawca: UIButton) {
        UIView.animate(withDuration: 0.2) {
            nadawca.transform = .identity
            nadawca.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        }
    }
    
    @objc private func wcisnietoAnulowanie() {
        animujWyjscie { [weak self] in
            self?.dismiss(animated: false) {
                self?.anulowano?()
            }
        }
    }
}

