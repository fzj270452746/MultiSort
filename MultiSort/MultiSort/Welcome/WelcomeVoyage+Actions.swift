
import UIKit

extension PodrozPowitalna {
    
    @objc func wcisnietoStartGry() {
        przyciskStartu.animujOdbicie()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            let selektor = KontrolerWyboruTrybu()
            selektor.modalPresentationStyle = .overFullScreen
            selektor.modalTransitionStyle = .crossDissolve
            selektor.wybrano = { [weak self] wariant in
                self?.uruchomGre(z: wariant)
            }
            selektor.anulowano = { [weak self] in
                self?.przyciskStartu.animujOdbicie()
            }
            self.present(selektor, animated: false)
        }
    }
    
    @objc func wcisnietoInstrukcje() {
        przyciskInstrukcji.animujOdbicie()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let podrozInstrukcji = PodrozInstrukcji()
            // 确保视图在转场前已准备好
            podrozInstrukcji.loadViewIfNeeded()
            self?.navigationController?.pushViewController(podrozInstrukcji, animated: false)  // 禁用动画避免闪烁
        }
    }
    
    @objc func wcisnietoRekordy() {
        przyciskRekordow.animujOdbicie()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let podrozRekordow = PodrozRekordow()
            // 确保视图在转场前已准备好
            podrozRekordow.loadViewIfNeeded()
            self?.navigationController?.pushViewController(podrozRekordow, animated: false)  // 禁用动画避免闪烁
        }
    }
    
    func animujWejscie() {
        kontenerTytulu.alpha = 0
        kontenerTytulu.transform = CGAffineTransform(translationX: 0, y: -60).scaledBy(x: 0.8, y: 0.8)
        
        etykietaPodtytulu.alpha = 0
        etykietaPodtytulu.transform = CGAffineTransform(translationX: 0, y: -20)
        
        stosKontenerowy.alpha = 0
        stosKontenerowy.transform = CGAffineTransform(translationX: 0, y: 80)
        
        efektSwietlny.alpha = 0
        efektSwietlny.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(
            withDuration: 1.2,
            delay: 0.2,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.6,
            options: .curveEaseOut,
            animations: {
                self.kontenerTytulu.alpha = 1
                self.kontenerTytulu.transform = .identity
            }
        )
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.5,
            options: .curveEaseOut,
            animations: {
                self.etykietaPodtytulu.alpha = 1
                self.etykietaPodtytulu.transform = .identity
            }
        )
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.4,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.stosKontenerowy.alpha = 1
                self.stosKontenerowy.transform = .identity
            },
            completion: { _ in
                self.animujPrzyciski()
            }
        )
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0.1,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.efektSwietlny.alpha = 0.6
                self.efektSwietlny.transform = .identity
            }
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if let widokEkranuStartowego = self.view.viewWithTag(556) {
                UIView.animate(withDuration: 0.4, animations: {
                    widokEkranuStartowego.alpha = 0
                }) { _ in
                    widokEkranuStartowego.removeFromSuperview()
                }
            }
        }
    }
    
    func animujPrzyciski() {
        let przyciski = [przyciskStartu, przyciskInstrukcji, przyciskRekordow]
        
        for (indeks, przycisk) in przyciski.enumerated() {
            przycisk.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            przycisk.alpha = 0.7
            
            UIView.animate(
                withDuration: 0.5,
                delay: Double(indeks) * 0.1,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.8,
                options: .curveEaseOut,
                animations: {
                    przycisk.transform = .identity
                    przycisk.alpha = 1.0
                }
            )
        }
    }
    
    func uruchomGre(z wariant: WariantGry) {
        let podrozGry = PodrozGry(wariant: wariant)
        // 确保视图在转场前已准备好
        podrozGry.loadViewIfNeeded()
        navigationController?.pushViewController(podrozGry, animated: false)  // 禁用动画避免闪烁
    }
}
