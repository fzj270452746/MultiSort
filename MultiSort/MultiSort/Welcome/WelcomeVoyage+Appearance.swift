
import UIKit

extension PodrozPowitalna {
    
    func skonfigurujWyglad() {
        skonfigurujTlo()
        skonfigurujEfektSwietlny()
        skonfigurujEtykieteTytulu()
        skonfigurujEtykietePodtytulu()
        skonfigurujStosKontenerowy()
        skonfigurujPrzyciski()
    }
    
    func skonfigurujTlo() {
        tloObrazowe.backgroundColor = .black  // 设置背景色避免图片加载前的闪烁
        tloObrazowe.image = UIImage(named: "multiSortImage")
        tloObrazowe.contentMode = .scaleAspectFill
        tloObrazowe.clipsToBounds = true
        
        let gradientNakladki = CAGradientLayer()
        gradientNakladki.colors = [
            UIColor(white: 0, alpha: 0.75).cgColor,
            UIColor(white: 0, alpha: 0.5).cgColor,
            UIColor(white: 0, alpha: 0.7).cgColor
        ]
        gradientNakladki.locations = [0.0, 0.5, 1.0]
        gradientNakladki.frame = UIScreen.main.bounds
        zaslonaNakladki.layer.insertSublayer(gradientNakladki, at: 0)
    }
    
    func skonfigurujEfektSwietlny() {
        let gradientSwietlny = CAGradientLayer()
        gradientSwietlny.colors = [
            UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 0.3).cgColor,
            UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 0.2).cgColor,
            UIColor(red: 0.85, green: 0.33, blue: 0.24, alpha: 0.25).cgColor
        ]
        gradientSwietlny.locations = [0.0, 0.5, 1.0]
        gradientSwietlny.type = .radial
        gradientSwietlny.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientSwietlny.endPoint = CGPoint(x: 0.5, y: 1.0)
        efektSwietlny.layer.insertSublayer(gradientSwietlny, at: 0)
        efektSwietlny.clipsToBounds = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            gradientSwietlny.frame = self.efektSwietlny.bounds
        }
    }
    
    func skonfigurujEtykieteTytulu() {
        etykietaTytulu.text = StaleZywotne.Tekst.tytulAplikacji
        etykietaTytulu.font = UIFont.systemFont(ofSize: 52, weight: .heavy)
        etykietaTytulu.textAlignment = .center
        etykietaTytulu.numberOfLines = 0
        etykietaTytulu.textColor = .white
        
        etykietaTytulu.layer.shadowColor = UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 0.8).cgColor
        etykietaTytulu.layer.shadowOffset = CGSize(width: 0, height: 0)
        etykietaTytulu.layer.shadowOpacity = 1.0
        etykietaTytulu.layer.shadowRadius = 20
        etykietaTytulu.layer.masksToBounds = false
    }
    
    func skonfigurujEtykietePodtytulu() {
        etykietaPodtytulu.text = "Sort Your Way to Victory"
        etykietaPodtytulu.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        etykietaPodtytulu.textColor = UIColor.white.withAlphaComponent(0.85)
        etykietaPodtytulu.textAlignment = .center
        etykietaPodtytulu.numberOfLines = 0
        etykietaPodtytulu.layer.shadowColor = UIColor.black.cgColor
        etykietaPodtytulu.layer.shadowOffset = CGSize(width: 0, height: 2)
        etykietaPodtytulu.layer.shadowOpacity = 0.5
        etykietaPodtytulu.layer.shadowRadius = 4
    }
    
    func skonfigurujStosKontenerowy() {
        stosKontenerowy.axis = .vertical
        stosKontenerowy.spacing = 18
        stosKontenerowy.distribution = .fillEqually
        stosKontenerowy.alignment = .fill
    }
    
    func skonfigurujPrzyciski() {
        skonfigurujNowoczesnyPrzycisk(
            przyciskStartu,
            tytul: StaleZywotne.Tekst.rozpocznijGre,
            nazwaIkony: "play.fill",
            koloryGradientu: [
                UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.0),
                UIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1.0)
            ],
            akcja: #selector(wcisnietoStartGry)
        )
        
        skonfigurujNowoczesnyPrzycisk(
            przyciskInstrukcji,
            tytul: StaleZywotne.Tekst.instrukcje,
            nazwaIkony: "book.fill",
            koloryGradientu: [
                UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.0),
                UIColor(red: 0.35, green: 0.75, blue: 0.95, alpha: 1.0)
            ],
            akcja: #selector(wcisnietoInstrukcje)
        )
        
        skonfigurujNowoczesnyPrzycisk(
            przyciskRekordow,
            tytul: StaleZywotne.Tekst.rekordy,
            nazwaIkony: "trophy.fill",
            koloryGradientu: [
                UIColor(red: 0.85, green: 0.33, blue: 0.24, alpha: 1.0),
                UIColor(red: 0.95, green: 0.45, blue: 0.35, alpha: 1.0)
            ],
            akcja: #selector(wcisnietoRekordy)
        )
    }
    
    func skonfigurujNowoczesnyPrzycisk(_ przycisk: UIButton, tytul: String, nazwaIkony: String, koloryGradientu: [UIColor], akcja: Selector) {
        przycisk.layer.cornerRadius = 22
        przycisk.layer.masksToBounds = false
        przycisk.backgroundColor = .clear  // 确保背景透明，不遮挡内容
        
        let warstwaGradientu = CAGradientLayer()
        warstwaGradientu.colors = koloryGradientu.map { $0.cgColor }
        warstwaGradientu.startPoint = CGPoint(x: 0, y: 0)
        warstwaGradientu.endPoint = CGPoint(x: 1, y: 1)
        warstwaGradientu.cornerRadius = 22
        warstwaGradientu.name = "gradientWarstwa"
        
        let warstwaSwietlna = CAGradientLayer()
        warstwaSwietlna.colors = [
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        warstwaSwietlna.startPoint = CGPoint(x: 0.5, y: 0)
        warstwaSwietlna.endPoint = CGPoint(x: 0.5, y: 0.3)
        warstwaSwietlna.cornerRadius = 22
        warstwaSwietlna.name = "swietlnaWarstwa"
        
        przycisk.layer.sublayers?.removeAll(where: { $0.name == "gradientWarstwa" || $0.name == "swietlnaWarstwa" })
        przycisk.layer.insertSublayer(warstwaGradientu, at: 0)
        przycisk.layer.insertSublayer(warstwaSwietlna, at: 1)
        
        przycisk.layer.shadowColor = koloryGradientu.first?.cgColor
        przycisk.layer.shadowOffset = CGSize(width: 0, height: 8)
        przycisk.layer.shadowOpacity = 0.5
        przycisk.layer.shadowRadius = 16
        przycisk.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 72), cornerRadius: 22).cgPath
        
        // 设置按钮类型和基本属性
        przycisk.contentHorizontalAlignment = .center
        przycisk.contentVerticalAlignment = .center
        przycisk.semanticContentAttribute = .forceLeftToRight
        
        // 设置图标 - 确保图标正确显示
        let konfiguracjaIkony = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        if let ikona = UIImage(systemName: nazwaIkony, withConfiguration: konfiguracjaIkony) {
            // 使用 alwaysOriginal 确保图标颜色正确
            let bialaIkona = ikona.withTintColor(.white, renderingMode: .alwaysOriginal)
            przycisk.setImage(bialaIkona, for: .normal)
            przycisk.setImage(bialaIkona, for: .highlighted)
            przycisk.setImage(bialaIkona, for: .selected)
            // 调试输出
        } else {
            
            if let ikona = UIImage(systemName: nazwaIkony) {
                przycisk.setImage(ikona, for: .normal)
                przycisk.tintColor = .white
            }
        }
        przycisk.tintColor = .white
        
        // 设置文字
        przycisk.setTitle(tytul, for: .normal)
        przycisk.setTitle(tytul, for: .highlighted)
        przycisk.setTitleColor(.white, for: .normal)
        przycisk.setTitleColor(.white, for: .highlighted)
        przycisk.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // 设置图标和文字之间的间距
        let odstepMiedzyIkonaATekstem: CGFloat = 12
        przycisk.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: odstepMiedzyIkonaATekstem)
        przycisk.titleEdgeInsets = UIEdgeInsets(top: 0, left: odstepMiedzyIkonaATekstem, bottom: 0, right: 0)
        
        // 确保内容区域对称
        przycisk.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 确保图标和文字视图在图层之上
        DispatchQueue.main.async {
            if let imageView = przycisk.imageView {
                przycisk.bringSubviewToFront(imageView)
            }
            if let titleLabel = przycisk.titleLabel {
                przycisk.bringSubviewToFront(titleLabel)
            }
        }
        
        let warstwaObramowania = CALayer()
        warstwaObramowania.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        warstwaObramowania.borderWidth = 1.5
        warstwaObramowania.cornerRadius = 22
        warstwaObramowania.frame = CGRect(x: 0, y: 0, width: 100, height: 72)
        warstwaObramowania.name = "obramowanie"
        przycisk.layer.insertSublayer(warstwaObramowania, at: 2)
        
        przycisk.addTarget(self, action: akcja, for: .touchUpInside)
        przycisk.addTarget(self, action: #selector(przyciskDotknietyWDol(_:)), for: .touchDown)
        przycisk.addTarget(self, action: #selector(przyciskDotknietyWGore(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc func przyciskDotknietyWDol(_ nadawca: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            nadawca.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            nadawca.alpha = 0.9
        }
        
        if let warstwaSwietlna = nadawca.layer.sublayers?.first(where: { $0.name == "swietlnaWarstwa" }) as? CAGradientLayer {
            UIView.animate(withDuration: 0.15) {
                warstwaSwietlna.opacity = 0.5
            }
        }
    }
    
    @objc func przyciskDotknietyWGore(_ nadawca: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            nadawca.transform = .identity
            nadawca.alpha = 1.0
        }
        
        if let warstwaSwietlna = nadawca.layer.sublayers?.first(where: { $0.name == "swietlnaWarstwa" }) as? CAGradientLayer {
            UIView.animate(withDuration: 0.25) {
                warstwaSwietlna.opacity = 1.0
            }
        }
    }
}
