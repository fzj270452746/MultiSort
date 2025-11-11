
import UIKit

class WelcomeVoyage: UIViewController {
    
    let backdropPortrayal = UIImageView()
    let overlayVeil = UIView()
    let titleLabel = UILabel()
    let startButton = UIButton(type: .system)
    let instructionsButton = UIButton(type: .system)
    let recordsButton = UIButton(type: .system)
    let containerStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleHierarchy()
        configureAppearance()
        establishConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        animateEntrance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新按钮渐变层的frame
        for button in [startButton, instructionsButton, recordsButton] {
            if let gradientLayer = button.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                gradientLayer.frame = button.bounds
            }
        }
    }
}

