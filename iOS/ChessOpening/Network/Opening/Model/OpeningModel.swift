//
//  BoardModel.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.17.
//

import Foundation
import UIKit

enum MoveType: Int {
    case mainbook
    case sidebook
    case gambit
    case brilliant
    case blunder
    case unknown
    
    func getImage() -> UIImage {
        switch self {
        case .mainbook:
            return UIImage(resource: .mainbook)
        case .sidebook:
            return UIImage(resource: .sidebook)
        case .gambit:
            return UIImage(resource: .gambit)
        case .brilliant:
            return UIImage(resource: .brilliant)
        case .blunder:
            return UIImage(resource: .blunder)
        case .unknown:
            return UIImage(resource: .bookGray)
        }
    }
    func getGrayImage() -> UIImage {
        switch self {
        case .mainbook, .sidebook:
            return UIImage(resource: .bookGray)
        case .gambit:
            return UIImage(resource: .gambitGray)
        case .brilliant:
            return UIImage(resource: .brilliantGray)
        case .blunder:
            return UIImage(resource: .blunderGray)
        case .unknown:
            return UIImage(resource: .bookGray)
        }
    }
    func toString() -> String {
        switch self {
        case .mainbook:
            return "Main Line"
        case .sidebook:
            return "Side Line"
        case .gambit:
            return "Gambit"
        case .brilliant:
            return "Brilliant"
        case .blunder:
            return "Blunder"
        case .unknown:
            return "Unknown"
        }
    }
}

struct OpeningModel {
    var title: String
    var info: String
    var moves: [MoveModel]
    var rate: (white: Int, draws: Int, black: Int)?
    
    struct MoveModel {
        var valid: Bool
        var pgn: String
        var type: MoveType
        var title: String
        var info: String
        var rate: (white: Int, draws: Int, black: Int)?
        
        init(moveEntity: OpeningEntity.OpeningResponseDataEntity.MoveEntity) {
            self.valid = true
            self.pgn = moveEntity.pgn ?? ""
            self.type = MoveType(rawValue: moveEntity.type ?? 0) ?? .unknown
            self.title = moveEntity.title ?? ""
            self.info = moveEntity.info ?? ""
        }
        init(lichessMoveModel: LichessModel.MoveModel) {
            self.valid = true
            self.pgn = lichessMoveModel.san ?? ""
            self.type = .unknown
            self.title = ""
            self.info = ""
            self.rate = lichessMoveModel.rate
        }
        init(pgn: String) {
            self.valid = false
            self.pgn = pgn
            self.type = .unknown
            self.title = ""
            self.info = ""
        }
    }
    
    init(openingEntity: OpeningEntity.OpeningResponseDataEntity, lichessModel: LichessModel) {
        self.title = openingEntity.title ?? lichessModel.opening?.name ?? ""
        self.info = openingEntity.info ?? ""
        self.moves = []
        if let moves = openingEntity.moves {
            for move in moves {
                self.moves.append(MoveModel(moveEntity: move))
            }
        }
        if let moves = lichessModel.moves {
            for move in moves {
                if let index = self.moves.firstIndex(where: { $0.pgn == move.san }) {
                    self.moves[index].rate = move.rate
                } else {
                    self.moves.append(MoveModel(lichessMoveModel: move))
                }
            }
        }
        self.rate = lichessModel.rate
    }
    init() {
        self.title = ""
        self.info = ""
        self.moves = []
    }
    
    func getValidMoves() -> [MoveModel] {
        return moves.compactMap({ $0.valid ? $0 : nil})
    }
    
    func getValidMovesCount() -> Int {
        return moves.count(where: { $0.valid })
    }
    
    mutating func appendMoves(engine: Engine) {
        for pgn in engine.getLegalMovesPGN() {
            if !(moves.contains(where: { $0.pgn == pgn })) {
                moves.append(MoveModel(pgn: pgn))
            }
        }
    }
}
