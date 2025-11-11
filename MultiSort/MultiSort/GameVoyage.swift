//
//  GameVoyage.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class GameVoyage: UIViewController {
    
    let variant: GameVariant
    
    let backdropPortrayal = UIImageView()
    let overlayVeil = UIView()
    let retreatButton = UIButton(type: .system)
    let timerLabel = UILabel()
    let scoreLabel = UILabel()
    let confirmButton = UIButton(type: .system)
    let shuffleButton = UIButton(type: .system)
    let rewindButton = UIButton(type: .system)
    let yieldButton = UIButton(type: .system)
    let suitSwitcherButton = UIButton(type: .system)
    let variantBadgeLabel = UILabel()
    let moveQuotaLabel = UILabel()
    let objectiveBoard = UIStackView()
    let commandRibbon = UIStackView()
    
    var objectiveLabels: [UILabel] = []
    var mindfulHintConstraints: [NSLayoutConstraint] = []
    
    var tileRowsVessels: [[TileVessel]] = []
    var rowContainers: [UIView] = []
    var layoutBlueprint = LayoutBlueprint(
        tileWidth: 45,
        tileHeight: 55,
        tileSpacing: 4,
        crossSpacing: 20,
        primaryLength: 527,
        secondaryLength: 45,
        topOffset: 100,
        rows: 9,
        columns: 3,
        movementAxis: .vertical
    )
    
    var chronometer: Timer?
    var elapsedSeconds: Int = 0
    var achievedScore: Int = 0
    var remainingSeconds: Int = 0
    var remainingMoves: Int = 0
    var rewindTokensRemaining: Int = 0
    var rewindCrates: [RewindCrate] = []
    var preMoveCrate: RewindCrate?
    var objectiveSequences: [[Int]] = []
    var suitSwitcherConstraints: [NSLayoutConstraint] = []
    var activeSuitIndex: Int = 0
    let availableCategories = TileElement.TileCategory.allCases
    
    // 使用新的交互管理器（点击交换）
    lazy var interactionManager: TileInteractionManager = {
        let manager = TileInteractionManager()
        manager.delegate = self
        return manager
    }()
    
    var hasRevealed: Bool = false
    var hasShownGuidance: Bool = false
    
    init(variant: GameVariant = .classicFlow) {
        self.variant = variant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVariantState()
        assembleHierarchy()
        configureAppearance()
        establishConstraints()
        initializeTileRows()
        commenceChronometer()
        updateScoreDisplay()
        updateMoveQuotaLabel()
        updateRewindButtonState()

        print("=== 布局信息 ===")
        print("屏幕宽度: \(view.bounds.width)")
        print("屏幕高度: \(view.bounds.height)")
        print("安全区 top: \(view.safeAreaInsets.top) bottom: \(view.safeAreaInsets.bottom)")
        print("麻将宽度: \(layoutBlueprint.tileWidth)")
        print("麻将高度: \(layoutBlueprint.tileHeight)")
        print("麻将间距: \(layoutBlueprint.tileSpacing)")
        print("主轴长度: \(layoutBlueprint.primaryLength)")
        print("顶部偏移: \(layoutBlueprint.topOffset)")
        print("================")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasShownGuidance {
            hasShownGuidance = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.displayDragGuidance()
            }
        }
    }
    
    deinit {
        chronometer?.invalidate()
    }
    
    var activeCategory: TileElement.TileCategory {
        guard variant.usesSuitCycler else { return availableCategories.first ?? .circles }
        let index = (activeSuitIndex % max(availableCategories.count, 1) + max(availableCategories.count, 1)) % max(availableCategories.count, 1)
        return availableCategories[index]
    }
}

