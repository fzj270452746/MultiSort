
import UIKit

class PodrozPowitalna: UIViewController {
    
    let tloObrazowe = UIImageView()
    let zaslonaNakladki = UIView()
    let etykietaTytulu = UILabel()
    let etykietaPodtytulu = UILabel()
    let przyciskStartu = UIButton(type: .system)
    let przyciskInstrukcji = UIButton(type: .system)
    let przyciskRekordow = UIButton(type: .system)
    let stosKontenerowy = UIStackView()
    let kontenerTytulu = UIView()
    let efektSwietlny = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        zlozHierarchie()
        skonfigurujWyglad()
        ustanowOgraniczenia()
    }
    
    private var czyWykonanoAnimacjeWejscia = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)  // 使用 false 避免闪烁
        // 只在首次显示时执行动画，避免返回时重复动画导致闪烁
        if !czyWykonanoAnimacjeWejscia {
            czyWykonanoAnimacjeWejscia = true
            animujWejscie()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for przycisk in [przyciskStartu, przyciskInstrukcji, przyciskRekordow] {
            if let warstwaGradientu = przycisk.layer.sublayers?.first(where: { $0.name == "gradientWarstwa" }) as? CAGradientLayer {
                warstwaGradientu.frame = przycisk.bounds
            }
            if let warstwaSwietlna = przycisk.layer.sublayers?.first(where: { $0.name == "swietlnaWarstwa" }) as? CAGradientLayer {
                warstwaSwietlna.frame = przycisk.bounds
            }
            if let warstwaObramowania = przycisk.layer.sublayers?.first(where: { $0.name == "obramowanie" }) as? CALayer {
                warstwaObramowania.frame = przycisk.bounds
                warstwaObramowania.cornerRadius = 22
            }
            
            // 确保按钮内容居中
            przycisk.contentHorizontalAlignment = .center
            przycisk.contentVerticalAlignment = .center
            
            // 强制刷新按钮内容显示
            przycisk.setNeedsLayout()
            przycisk.layoutIfNeeded()
            
            // 确保图标和文字视图在图层之上
            if let imageView = przycisk.imageView {
                przycisk.bringSubviewToFront(imageView)
                imageView.tintColor = .white
                imageView.contentMode = .scaleAspectFit
                imageView.isHidden = false
                // 调试：检查图标是否存在
                if imageView.image == nil {
                }
            }
            if let titleLabel = przycisk.titleLabel {
                przycisk.bringSubviewToFront(titleLabel)
                titleLabel.isHidden = false
            }
        }
        
        efektSwietlny.layer.cornerRadius = efektSwietlny.bounds.width / 2
        
        if let gradientSwietlny = efektSwietlny.layer.sublayers?.first as? CAGradientLayer {
            gradientSwietlny.frame = efektSwietlny.bounds
        }
        
        if let gradientNakladki = zaslonaNakladki.layer.sublayers?.first as? CAGradientLayer {
            gradientNakladki.frame = zaslonaNakladki.bounds
        }
    }
}
