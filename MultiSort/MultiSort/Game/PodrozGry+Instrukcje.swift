

import UIKit

extension PodrozGry {
    
    func wyswietlInstrukcjePrzeciagania() {
        if wariant.uzywaUkladuSiatki {
            guard let siatka = naczyniaWierszyKafelkow.first, !siatka.isEmpty else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.wyswietlInstrukcjeSiatki(dla: siatka)
            }
        } else {
            guard naczyniaWierszyKafelkow.count == 3 else { return }
            for (indeksKolumny, kolumna) in naczyniaWierszyKafelkow.enumerated() {
                guard kolumna.count >= 2 else { continue }
                
                let opoznienie = Double(indeksKolumny) * 0.8
                DispatchQueue.main.asyncAfter(deadline: .now() + opoznienie) { [weak self] in
                    self?.wyswietlInstrukcjeKolumny(dla: kolumna, na: indeksKolumny)
                }
            }
        }
    }
    
    func wyswietlInstrukcjeKolumny(dla kolumna: [NaczynieKafelka], na indeksKolumny: Int) {
        guard !kolumna.isEmpty else { return }
        
        guard let minimalneNaczynie = kolumna.min(by: { $0.element.wartosc < $1.element.wartosc }) else { return }
        
        let naczynieDemonstracyjne = minimalneNaczynie
        let oryginalnaRama = naczynieDemonstracyjne.frame
        
        let osRuchu = wariant.osRuchu
        let pozycjaDocelowa = CGFloat(0)
        
        let widokIkonyReki = utworzWskaznikReki(dla: osRuchu)
        naczynieDemonstracyjne.superview?.addSubview(widokIkonyReki)
        
        widokIkonyReki.center = CGPoint(
            x: naczynieDemonstracyjne.frame.midX,
            y: naczynieDemonstracyjne.frame.midY
        )
        
        UIView.animateKeyframes(
            withDuration: 3.0,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                    naczynieDemonstracyjne.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    widokIkonyReki.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    widokIkonyReki.alpha = 1.0
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3) {
                    switch osRuchu {
                    case .vertical:
                        naczynieDemonstracyjne.frame.origin.y = pozycjaDocelowa
                        widokIkonyReki.center.y = naczynieDemonstracyjne.frame.midY
                    case .horizontal:
                        naczynieDemonstracyjne.frame.origin.x = pozycjaDocelowa
                        widokIkonyReki.center.x = naczynieDemonstracyjne.frame.midX
                    @unknown default:
                        break
                    }
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.15) {
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.25) {
                    naczynieDemonstracyjne.frame = oryginalnaRama
                    widokIkonyReki.center = CGPoint(x: naczynieDemonstracyjne.frame.midX, y: naczynieDemonstracyjne.frame.midY)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                    naczynieDemonstracyjne.frame = oryginalnaRama
                    naczynieDemonstracyjne.transform = .identity
                    widokIkonyReki.alpha = 0
                    widokIkonyReki.center = CGPoint(
                        x: naczynieDemonstracyjne.frame.midX,
                        y: naczynieDemonstracyjne.frame.midY
                    )
                }
            },
            completion: { _ in
                widokIkonyReki.removeFromSuperview()
            }
        )
        
        dodajAnimacjePulsowania(do: naczynieDemonstracyjne)
    }
    
    func wyswietlInstrukcjeSiatki(dla naczynia: [NaczynieKafelka]) {
        guard let naczynieDemonstracyjne = naczynia.min(by: { $0.element.wartosc < $1.element.wartosc }),
              let kontener = naczynieDemonstracyjne.superview else { return }
        let oryginalnaRama = naczynieDemonstracyjne.frame
        let poczatekDocelowy = CGPoint(x: 0, y: 0)
        let widokIkonyReki = utworzWskaznikReki(dla: .horizontal)
        kontener.addSubview(widokIkonyReki)
        widokIkonyReki.center = CGPoint(x: naczynieDemonstracyjne.frame.midX, y: naczynieDemonstracyjne.frame.midY)
        
        UIView.animateKeyframes(
            withDuration: 3.0,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                    naczynieDemonstracyjne.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    widokIkonyReki.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    widokIkonyReki.alpha = 1.0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3) {
                    naczynieDemonstracyjne.frame.origin = poczatekDocelowy
                    widokIkonyReki.center = CGPoint(x: naczynieDemonstracyjne.frame.midX, y: naczynieDemonstracyjne.frame.midY)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.15) {}
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.25) {
                    naczynieDemonstracyjne.frame = oryginalnaRama
                    widokIkonyReki.center = CGPoint(x: naczynieDemonstracyjne.frame.midX, y: naczynieDemonstracyjne.frame.midY)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {
                    naczynieDemonstracyjne.frame = oryginalnaRama
                    naczynieDemonstracyjne.transform = .identity
                    widokIkonyReki.alpha = 0
                }
            }, completion: { _ in
                widokIkonyReki.removeFromSuperview()
            })
        dodajAnimacjePulsowania(do: naczynieDemonstracyjne)
    }
    
    func utworzWskaznikReki(dla os: NSLayoutConstraint.Axis) -> UIView {
        let kontenerWidoku = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        kontenerWidoku.backgroundColor = .clear
        kontenerWidoku.alpha = 0
        
        let widokObrazu = UIImageView(frame: kontenerWidoku.bounds)
        let konfiguracja = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        let nazwaSymbolu: String = {
            switch os {
            case .horizontal:
                return "hand.point.left.fill"
            default:
                return "hand.point.up.fill"
            }
        }()
        widokObrazu.image = UIImage(systemName: nazwaSymbolu, withConfiguration: konfiguracja)
        widokObrazu.tintColor = StaleZywotne.Paleta.odcienPodstawowy
        widokObrazu.contentMode = .scaleAspectFit
        
        widokObrazu.layer.shadowColor = UIColor.black.cgColor
        widokObrazu.layer.shadowOffset = CGSize(width: 0, height: 2)
        widokObrazu.layer.shadowOpacity = 0.3
        widokObrazu.layer.shadowRadius = 4
        
        kontenerWidoku.addSubview(widokObrazu)
        return kontenerWidoku
    }
    
    func dodajAnimacjePulsowania(do naczynie: NaczynieKafelka) {
        let animacjaPulsowania = CABasicAnimation(keyPath: "opacity")
        animacjaPulsowania.fromValue = 1.0
        animacjaPulsowania.toValue = 0.6
        animacjaPulsowania.duration = 0.5
        animacjaPulsowania.autoreverses = true
        animacjaPulsowania.repeatCount = 6
        animacjaPulsowania.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        naczynie.layer.add(animacjaPulsowania, forKey: "animacjaPulsowania")
    }
}


