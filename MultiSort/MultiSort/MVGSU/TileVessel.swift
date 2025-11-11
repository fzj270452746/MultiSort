//
//  TileVessel.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

class TileVessel: UIView {
    
    let portrayal: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let magnitudeLabel: UILabel = {
        let label = UILabel()
        let tileHeight = VibrantConstants.Measurements.tileHeight
        let labelSide = max(28, tileHeight * 0.65)
        let fontSize: CGFloat = max(18, labelSide * 0.55)
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
        label.textColor = VibrantConstants.Palette.secondaryTint
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        label.layer.cornerRadius = labelSide / 2
        label.layer.masksToBounds = true
        label.layer.borderWidth = 2
        label.layer.borderColor = VibrantConstants.Palette.secondaryTint.cgColor
        return label
    }()
    
    let element: TileElement
    var originalIndex: Int
    var currentIndex: Int
    
    init(element: TileElement, index: Int) {
        self.element = element
        self.originalIndex = index
        self.currentIndex = index
        super.init(frame: .zero)
        
        assembleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assembleView() {
        backgroundColor = .clear
        layer.cornerRadius = 3
        layer.masksToBounds = false
        applySubtleShadow()
        
        addSubview(portrayal)
        addSubview(magnitudeLabel)
        
        NSLayoutConstraint.activate([
            portrayal.topAnchor.constraint(equalTo: topAnchor),
            portrayal.leadingAnchor.constraint(equalTo: leadingAnchor),
            portrayal.trailingAnchor.constraint(equalTo: trailingAnchor),
            portrayal.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            magnitudeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            magnitudeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            magnitudeLabel.widthAnchor.constraint(equalToConstant: max(28, VibrantConstants.Measurements.tileHeight * 0.65)),
            magnitudeLabel.heightAnchor.constraint(equalToConstant: max(28, VibrantConstants.Measurements.tileHeight * 0.65))
        ])
        
        portrayal.image = element.portrayal
    }
    
    func revealMagnitude() {
        magnitudeLabel.text = "\(element.magnitude)"
        
        UIView.animate(withDuration: VibrantConstants.Motion.standardDuration) {
            self.magnitudeLabel.isHidden = false
            self.magnitudeLabel.alpha = 1.0
        }
    }
    
    func concealMagnitude() {
        UIView.animate(withDuration: VibrantConstants.Motion.standardDuration) {
            self.magnitudeLabel.alpha = 0
        } completion: { _ in
            self.magnitudeLabel.isHidden = true
        }
    }
}

