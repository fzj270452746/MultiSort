//
//  RecordsVoyage+TableView.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import UIKit

extension RecordsVoyage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memorables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemorableCell", for: indexPath) as? MemorableCell else {
            return UITableViewCell()
        }
        
        let memorable = memorables[indexPath.row]
        cell.configureWithMemorable(memorable, rank: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - MemorableCell
class MemorableCell: UITableViewCell {
    
    let containerView = UIView()
    let rankLabel = UILabel()
    let scoreLabel = UILabel()
    let variantLabel = UILabel()
    let timeLabel = UILabel()
    let dateLabel = UILabel()
    let perfectBadge = UILabel()
    let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        assembleCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assembleCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(rankLabel)
        containerView.addSubview(scoreLabel)
        containerView.addSubview(variantLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(detailLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(perfectBadge)
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = VibrantConstants.Measurements.cornerRadius
        containerView.applySubtleShadow()
        
        rankLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        rankLabel.textColor = VibrantConstants.Palette.primaryTint
        
        scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        scoreLabel.textColor = VibrantConstants.Palette.pureWhite
        
        variantLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        variantLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        timeLabel.textColor = VibrantConstants.Palette.pureWhite
        
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        detailLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        
        perfectBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        perfectBadge.textColor = VibrantConstants.Palette.pureWhite
        perfectBadge.backgroundColor = VibrantConstants.Palette.primaryTint
        perfectBadge.text = "★ PERFECT"
        perfectBadge.textAlignment = .center
        perfectBadge.layer.cornerRadius = 10
        perfectBadge.layer.masksToBounds = true
        perfectBadge.isHidden = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        variantLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        perfectBadge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 20),
            
            scoreLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 5),
            
            variantLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),
            variantLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 5),
            variantLabel.trailingAnchor.constraint(lessThanOrEqualTo: perfectBadge.leadingAnchor, constant: -12),
            
            timeLabel.topAnchor.constraint(equalTo: variantLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 5),
            
            detailLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 5),
            
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 5),
            
            perfectBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            perfectBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            perfectBadge.widthAnchor.constraint(equalToConstant: 90),
            perfectBadge.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configureWithMemorable(_ memorable: GameMemorable, rank: Int) {
        rankLabel.text = "\(rank)"
        scoreLabel.text = "Score: \(memorable.achievedScore)"
        variantLabel.text = memorable.variantDisplayName
        timeLabel.text = "Time: \(memorable.formattedDuration)"
        if let moves = memorable.moveFootprint {
            let rewindText = (memorable.usedRewind ?? false) ? "Rewind Used" : "Rewind Unused"
            if let residual = memorable.formattedResidualTime {
                detailLabel.text = "Moves: \(moves) • Time Left: \(residual) • \(rewindText)"
            } else {
                detailLabel.text = "Moves: \(moves) • \(rewindText)"
            }
        } else if let residual = memorable.formattedResidualTime {
            detailLabel.text = "Time Left: \(residual)"
        } else {
            detailLabel.text = ""
        }
        detailLabel.isHidden = (detailLabel.text ?? "").isEmpty
        dateLabel.text = memorable.formattedDate
        perfectBadge.isHidden = !memorable.wasPerfect
    }
}

