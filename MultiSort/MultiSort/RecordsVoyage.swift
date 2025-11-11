//
//  RecordsVoyage.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class RecordsVoyage: BaseViewController {
    
    let titleLabel = UILabel()
    let tableVessel = UITableView()
    let emptyStateLabel = UILabel()
    let obliterateButton = UIButton(type: .system)
    
    var memorables: [GameMemorable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemorables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemorables()
    }
    
    // MARK: - ViewConfiguration Override
    override func assembleHierarchy() {
        super.assembleHierarchy()
        addRetreatButton()
        configureRetreatButton(target: self, action: #selector(retreatTapped))
        
        view.addSubview(titleLabel)
        view.addSubview(tableVessel)
        view.addSubview(emptyStateLabel)
        view.addSubview(obliterateButton)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        configureTitle()
        configureTable()
        configureEmptyState()
        configureObliterateButton()
    }
    
    override func establishConstraints() {
        super.establishConstraints()
        setupRecordsConstraints()
    }
}

