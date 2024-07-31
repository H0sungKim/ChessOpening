//
//  LichessEntity.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.29.
//

import Foundation

struct LichessEntity: Codable {
    struct OpeningEntity: Codable {
        var eco: String?
        var name: String?
    }
    struct MoveEntity: Codable {
        var san: String?
        var white: Int?
        var draws: Int?
        var black: Int?
    }
    var opening: OpeningEntity?
    var white: Int?
    var draws: Int?
    var black: Int?
    var moves: [MoveEntity]?
}
