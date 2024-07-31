//
//  LichessModel.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.30.
//

import Foundation

struct LichessModel {
    struct OpeningModel {
        var eco: String?
        var name: String?
        
        init(openingEntity: LichessEntity.OpeningEntity) {
            self.eco = openingEntity.eco
            self.name = openingEntity.name
        }
    }
    struct MoveModel {
        var san: String?
        var rate: (white: Int, draws: Int, black: Int)?
        
        init(moveEntity: LichessEntity.MoveEntity) {
            self.san = moveEntity.san
            if let white = moveEntity.white, let draws = moveEntity.draws, let black = moveEntity.black {
                self.rate = (white: white, draws: draws, black: black)
            }
        }
    }
    var opening: OpeningModel?
    var rate: (white: Int, draws: Int, black: Int)?
    var moves: [MoveModel]?
    
    init(lichessEntity: LichessEntity) {
        if let opening = lichessEntity.opening {
            self.opening = OpeningModel(openingEntity: opening)
        }
        if let white = lichessEntity.white, let draws = lichessEntity.draws, let black = lichessEntity.black {
            self.rate = (white: white, draws: draws, black: black)
        }
        self.moves = lichessEntity.moves?.map { MoveModel(moveEntity: $0) }
    }
}
