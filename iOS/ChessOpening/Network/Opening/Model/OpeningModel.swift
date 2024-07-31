//
//  BoardModel.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.17.
//

import Foundation

struct OpeningModel {
    var title: String
    var info: String
    var moves: [MoveModel]
    var rate: (white: Int, draws: Int, black: Int)?
    
    struct MoveModel {
        var pgn: String
        var type: MoveType
        var title: String
        var info: String
        var rate: (white: Int, draws: Int, black: Int)?
        init(moveEntity: OpeningEntity.OpeningResponseDataEntity.MoveEntity) {
            self.pgn = moveEntity.pgn ?? ""
            self.type = MoveType(rawValue: moveEntity.type ?? 0) ?? .mainbook
            self.title = moveEntity.title ?? ""
            self.info = moveEntity.info ?? ""
        }
        init(optionalMoveModel: OptionalOpeningModel.MoveModel) {
            self.pgn = optionalMoveModel.pgn ?? ""
            self.type = optionalMoveModel.type ?? .mainbook
            self.title = optionalMoveModel.title ?? ""
            self.info = optionalMoveModel.info ?? ""
        }
        init(integratedMoveModel: IntegratedOpeningModel.MoveModel, includeRate: Bool) {
            self.pgn = integratedMoveModel.pgn
            self.type = integratedMoveModel.type
            self.title = integratedMoveModel.title
            self.info = integratedMoveModel.info
            if includeRate {
                self.rate = integratedMoveModel.rate
            }
        }
        init(pgn: String) {
            self.pgn = pgn
            self.type = .mainbook
            self.title = ""
            self.info = ""
        }
        
    }
    
    init(openingEntity: OpeningEntity.OpeningResponseDataEntity) {
        self.title = openingEntity.title ?? ""
        self.info = openingEntity.info ?? ""
        self.moves = openingEntity.moves?.map { MoveModel(moveEntity: $0) } ?? []
    }
    init(optionalOpeningModel: OptionalOpeningModel) {
        self.title = optionalOpeningModel.title ?? ""
        self.info = optionalOpeningModel.info ?? ""
        self.moves = optionalOpeningModel.moves?.map { MoveModel(optionalMoveModel: $0) } ?? []
    }
    init(integratedOpeningModel: IntegratedOpeningModel, includeRate: Bool) {
        self.title = integratedOpeningModel.title
        self.info = integratedOpeningModel.info
        self.moves = integratedOpeningModel.moves.filter({ $0.valid }).map({ MoveModel(integratedMoveModel: $0, includeRate: includeRate) })
        if includeRate {
            self.rate = integratedOpeningModel.rate
        }
    }
    init() {
        self.title = ""
        self.info = ""
        self.moves = []
    }
}
