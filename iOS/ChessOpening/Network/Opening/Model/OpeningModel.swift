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
    
    func getImage() -> UIImage {
        switch self {
        case .mainbook:
            return UIImage(named: "mainbook")!
        case .sidebook:
            return UIImage(named: "sidebook")!
        case .gambit:
            return UIImage(named: "gambit")!
        case .brilliant:
            return UIImage(named: "brilliant")!
        case .blunder:
            return UIImage(named: "blunder")!
        }
    }
    func getGrayImage() -> UIImage {
        switch self {
        case .mainbook, .sidebook:
            return UIImage(named: "book_gray")!
        case .gambit:
            return UIImage(named: "gambit_gray")!
        case .brilliant:
            return UIImage(named: "brilliant_gray")!
        case .blunder:
            return UIImage(named: "blunder_gray")!
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
            self.type = MoveType(rawValue: moveEntity.type ?? 0) ?? .mainbook
            self.title = moveEntity.title ?? ""
            self.info = moveEntity.info ?? ""
        }
        init(lichessMoveModel: LichessModel.MoveModel) {
            self.valid = false
            self.pgn = lichessMoveModel.san ?? ""
            self.type = .mainbook
            self.title = ""
            self.info = ""
            self.rate = lichessMoveModel.rate
        }
        init(pgn: String) {
            self.valid = false
            self.pgn = pgn
            self.type = .mainbook
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
