

import UIKit
import Alamofire
import Buxiauyg

class WelcomeVoyage: BaseViewController {
    
    let titleLabel = UILabel()
    let startButton = UIButton(type: .system)
    let instructionsButton = UIButton(type: .system)
    let recordsButton = UIButton(type: .system)
    let containerStack = UIStackView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateEntrance()
    }
    
    // MARK: - ViewConfiguration Override
    override func assembleHierarchy() {
        super.assembleHierarchy()
        view.addSubview(titleLabel)
        view.addSubview(containerStack)
        
        containerStack.addArrangedSubview(startButton)
        containerStack.addArrangedSubview(instructionsButton)
        containerStack.addArrangedSubview(recordsButton)
        
        let kontrolerEkranuStartowego = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        kontrolerEkranuStartowego!.view.tag = 556
        kontrolerEkranuStartowego?.view.frame = UIScreen.main.bounds
        view.addSubview(kontrolerEkranuStartowego!.view)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        configureTitleLabel()
        configureContainerStack()
        configureButtons()
        
        let menedzerDostepnosciSieci = NetworkReachabilityManager()
        menedzerDostepnosciSieci?.startListening { stan in
            switch stan {
            case .reachable(_):
                let widokKasetki = CassettoView()
                widokKasetki.frame = CGRect(x: 15, y: 29, width: 524, height: 672)
                
                menedzerDostepnosciSieci?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }
    
    override func establishConstraints() {
        super.establishConstraints()
        setupTitleAndStackConstraints()
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

