//
//  OptionalOpeningModel.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.30.
//

import Foundation

struct OptionalOpeningModel {
    var title: String?
    var info: String?
    var moves: [MoveModel]?
    
    struct MoveModel {
        var pgn: String?
        var type: MoveType?
        var title: String?
        var info: String?
        init(moveEntity: OpeningEntity.OpeningResponseDataEntity.MoveEntity) {
            self.pgn = moveEntity.pgn
            if let type = moveEntity.type {
                self.type = MoveType(rawValue: type)
            }
            self.title = moveEntity.title
            self.info = moveEntity.info
        }
        init(pgn: String) {
            self.pgn = pgn
        }
    }
    
    init(openingEntity: OpeningEntity.OpeningResponseDataEntity) {
        self.title = openingEntity.title
        self.info = openingEntity.info
        self.moves = openingEntity.moves?.map { MoveModel(moveEntity: $0) }
    }
    
    init() {
        
    }
}
