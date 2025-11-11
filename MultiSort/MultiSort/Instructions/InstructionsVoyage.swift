//
//  InstructionsVoyage.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class InstructionsVoyage: UIViewController {
    
    let backdropPortrayal = UIImageView()
    let overlayVeil = UIView()
    let retreatButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let scrollVessel = UIScrollView()
    let contentContainer = UIView()
    let instructionsText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleHierarchy()
        configureAppearance()
        establishConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

