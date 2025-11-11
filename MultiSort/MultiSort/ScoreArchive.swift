//
//  ScoreArchive.swift
//  MultiSort
//
//  Created by Zhao on 2025/11/4.
//

import Foundation

// MARK: - GameMemorable
struct GameMemorable: Codable {
    let timestamp: Date
    let elapsedSeconds: Int
    let achievedScore: Int
    let wasPerfect: Bool
    let variantIdentifier: String
    let moveFootprint: Int?
    let residualTime: Int?
    let usedRewind: Bool?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case elapsedSeconds
        case achievedScore
        case wasPerfect
        case variantIdentifier
        case moveFootprint
        case residualTime
        case usedRewind
    }
    
    init(timestamp: Date, elapsedSeconds: Int, achievedScore: Int, wasPerfect: Bool, variantIdentifier: String, moveFootprint: Int?, residualTime: Int?, usedRewind: Bool?) {
        self.timestamp = timestamp
        self.elapsedSeconds = elapsedSeconds
        self.achievedScore = achievedScore
        self.wasPerfect = wasPerfect
        self.variantIdentifier = variantIdentifier
        self.moveFootprint = moveFootprint
        self.residualTime = residualTime
        self.usedRewind = usedRewind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        elapsedSeconds = try container.decode(Int.self, forKey: .elapsedSeconds)
        achievedScore = try container.decode(Int.self, forKey: .achievedScore)
        wasPerfect = try container.decode(Bool.self, forKey: .wasPerfect)
        variantIdentifier = try container.decodeIfPresent(String.self, forKey: .variantIdentifier) ?? GameVariant.classicFlow.identifier
        moveFootprint = try container.decodeIfPresent(Int.self, forKey: .moveFootprint)
        residualTime = try container.decodeIfPresent(Int.self, forKey: .residualTime)
        usedRewind = try container.decodeIfPresent(Bool.self, forKey: .usedRewind)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(elapsedSeconds, forKey: .elapsedSeconds)
        try container.encode(achievedScore, forKey: .achievedScore)
        try container.encode(wasPerfect, forKey: .wasPerfect)
        try container.encode(variantIdentifier, forKey: .variantIdentifier)
        try container.encodeIfPresent(moveFootprint, forKey: .moveFootprint)
        try container.encodeIfPresent(residualTime, forKey: .residualTime)
        try container.encodeIfPresent(usedRewind, forKey: .usedRewind)
    }
    
    var formattedDuration: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var variantDisplayName: String {
        GameVariant.variant(for: variantIdentifier).displayName
    }
    
    var formattedResidualTime: String? {
        guard let residualTime = residualTime else { return nil }
        let minutes = residualTime / 60
        let seconds = residualTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - ScoreArchive
class ScoreArchive {
    static let singleton = ScoreArchive()
    
    private let memorableKey = VibrantConstants.StorageKeys.gameRecords
    
    private init() {}
    
    func preserveMemorable(_ memorable: GameMemorable) {
        var memorables = retrieveMemorables()
        memorables.append(memorable)
        memorables.sort { $0.achievedScore > $1.achievedScore }
        
        if let encoded = try? JSONEncoder().encode(memorables) {
            UserDefaults.standard.set(encoded, forKey: memorableKey)
        }
    }
    
    func retrieveMemorables() -> [GameMemorable] {
        guard let data = UserDefaults.standard.data(forKey: memorableKey),
              let decoded = try? JSONDecoder().decode([GameMemorable].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func obliterateAllMemorables() {
        UserDefaults.standard.removeObject(forKey: memorableKey)
    }
}

