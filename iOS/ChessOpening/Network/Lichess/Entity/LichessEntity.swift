//
//  LichessEntity.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.29.
//

import Foundation

struct LichessEntity: Codable {
    var opening: OpeningEntity?
    struct OpeningEntity: Codable {
        var eco: String?
        var name: String?
    }
    var white: Int?
    var draws: Int?
    var black: Int?
    var moves: [MoveEntity]?
    struct MoveEntity: Codable {
        var san: String?
        var white: Int?
        var draws: Int?
        var black: Int?
    }
}
