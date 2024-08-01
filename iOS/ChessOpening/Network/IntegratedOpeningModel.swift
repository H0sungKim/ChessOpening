//
//  IntegratedOpeningModel.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.29.
//

import Foundation
import UIKit
import RxSwift

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

struct IntegratedOpeningModel {
    var fen: String
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
        
        init(openingMoveModel: OptionalOpeningModel.MoveModel) {
            self.valid = true
            self.pgn = openingMoveModel.pgn ?? ""
            self.type = openingMoveModel.type ?? .mainbook
            self.title = openingMoveModel.title ?? ""
            self.info = openingMoveModel.info ?? ""
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
    
    init(openingModel: OptionalOpeningModel?, lichessModel: LichessModel?, fen: String, engine: Engine?) {
        self.fen = fen
        self.title = openingModel?.title ?? lichessModel?.opening?.name ?? ""
        self.info = openingModel?.info ?? ""
        self.moves = []
        if let moves = openingModel?.moves {
            for move in moves {
                self.moves.append(MoveModel(openingMoveModel: move))
            }
        }
        if let moves = lichessModel?.moves {
            for move in moves {
                if let index = self.moves.firstIndex(where: { $0.pgn == move.san }) {
                    self.moves[index].rate = move.rate
                } else {
                    self.moves.append(MoveModel(lichessMoveModel: move))
                }
            }
        }
        if let engine = engine {
            for pgn in engine.getLegalMovesPGN() {
                if !(self.moves.contains(where: { $0.pgn == pgn })) {
                    self.moves.append(MoveModel(pgn: pgn))
                }
            }
        }
        self.rate = lichessModel?.rate
    }
}
