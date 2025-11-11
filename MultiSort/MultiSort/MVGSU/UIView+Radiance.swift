
import UIKit

extension UIView {
    
    func zastosujPromiennyCien() {
        layer.shadowColor = StaleZywotne.Paleta.glebokiCien.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
    
    func zastosujDelikatnyCien() {
        layer.shadowColor = StaleZywotne.Paleta.glebokiCien.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func animujOdbicie() {
        UIView.animate(
            withDuration: StaleZywotne.Ruch.czasTrwaniaOdbicia,
            delay: 0,
            usingSpringWithDamping: StaleZywotne.Ruch.tlumienieSprezyny,
            initialSpringVelocity: StaleZywotne.Ruch.predkoscSprezyny,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            },
            completion: { _ in
                UIView.animate(withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy) {
                    self.transform = .identity
                }
            }
        )
    }
    
    func animujPulsowanie() {
        UIView.animate(
            withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy,
            animations: {
                self.alpha = 0.6
            },
            completion: { _ in
                UIView.animate(withDuration: StaleZywotne.Ruch.czasTrwaniaStandardowy) {
                    self.alpha = 1.0
                }
            }
        )
    }
    
    func animujWstrzasanie() {
        let animacja = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animacja.timingFunction = CAMediaTimingFunction(name: .linear)
        animacja.duration = 0.6
        animacja.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animacja, forKey: "shake")
    }
}
