//
//  RecordsVoyage.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class RecordsVoyage: UIViewController {
    
    let backdropPortrayal = UIImageView()
    let overlayVeil = UIView()
    let retreatButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let tableVessel = UITableView()
    let emptyStateLabel = UILabel()
    let obliterateButton = UIButton(type: .system)
    
    var memorables: [GameMemorable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleHierarchy()
        configureAppearance()
        establishConstraints()
        loadMemorables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadMemorables()
    }
}

