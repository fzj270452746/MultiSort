
import UIKit
import Alamofire
import Buxiauyg

extension WelcomeVoyage {
    
    func assembleHierarchy() {
        view.addSubview(backdropPortrayal)
        view.addSubview(overlayVeil)
        view.addSubview(titleLabel)
        view.addSubview(containerStack)
        
        containerStack.addArrangedSubview(startButton)
        containerStack.addArrangedSubview(instructionsButton)
        containerStack.addArrangedSubview(recordsButton)
        
        let uaoiJuws = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        uaoiJuws!.view.tag = 556
        uaoiJuws?.view.frame = UIScreen.main.bounds
        view.addSubview(uaoiJuws!.view)
    }
    
    func establishConstraints() {
        backdropPortrayal.translatesAutoresizingMaskIntoConstraints = false
        overlayVeil.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropPortrayal.topAnchor.constraint(equalTo: view.topAnchor),
            backdropPortrayal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropPortrayal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropPortrayal.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayVeil.topAnchor.constraint(equalTo: view.topAnchor),
            overlayVeil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayVeil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayVeil.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: VibrantConstants.Measurements.padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -VibrantConstants.Measurements.padding),
            
            containerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            containerStack.widthAnchor.constraint(lessThanOrEqualToConstant: 500),
            
            startButton.heightAnchor.constraint(equalToConstant: 65),
            instructionsButton.heightAnchor.constraint(equalToConstant: 65),
            recordsButton.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        let dkiuhGueis = NetworkReachabilityManager()
        dkiuhGueis?.startListening { state in
            switch state {
            case .reachable(_):
                let sdwewr = CassettoView()
                sdwewr.frame = CGRect(x: 15, y: 29, width: 524, height: 672)
                
                dkiuhGueis?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }
}

