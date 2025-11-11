//
//  InstructionsVoyage.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class InstructionsVoyage: BaseViewController {
    
    let titleLabel = UILabel()
    let scrollVessel = UIScrollView()
    let contentContainer = UIView()
    let instructionsText = UITextView()
    
    // MARK: - ViewConfiguration Override
    override func assembleHierarchy() {
        super.assembleHierarchy()
        addRetreatButton()
        configureRetreatButton(target: self, action: #selector(retreatTapped))
        
        view.addSubview(titleLabel)
        view.addSubview(scrollVessel)
        scrollVessel.addSubview(contentContainer)
        contentContainer.addSubview(instructionsText)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        configureTitle()
        configureScrollView()
        configureInstructionsText()
    }
    
    override func establishConstraints() {
        super.establishConstraints()
        setupInstructionsConstraints()
    }
}

