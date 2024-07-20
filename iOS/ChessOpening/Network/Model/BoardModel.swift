//
//  BoardModel.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.17.
//

/*
{
    "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -" : {
        "title": "King’s Pawn Opening",
        "info": "Sample",
        "moves": [
            { "pgn": "e5", "type": 0, "title": "Open Game", "info": "most common move" },
            { "pgn": "c5", "type": 1, "title": "Sicilian Defence", "info": "master's common move" }
        ]
    }
}
*/

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

struct BoardModel {
    var title: String
    var info: String
    var moves: [MoveModel]
    
    struct MoveModel {
        var pgn: String
        var type: MoveType
        var title: String
        var info: String
        init(moveEntity: BoardEntity.BoardResponseDataEntity.MoveEntity) {
            self.pgn = moveEntity.pgn ?? ""
            self.type = MoveType(rawValue: moveEntity.type ?? 0) ?? .mainbook
            self.title = moveEntity.title ?? ""
            self.info = moveEntity.info ?? ""
        }
        init(pgn: String) {
            self.pgn = pgn
            self.type = .mainbook
            self.title = "정보가 없습니다."
            self.info = ""
        }
        init(moveModelForEdit: MoveModelForEdit) {
            self.pgn = moveModelForEdit.pgn
            self.type = moveModelForEdit.type
            self.title = moveModelForEdit.title
            self.info = moveModelForEdit.info
        }
    }
    
    init(boardEntity: BoardEntity.BoardResponseDataEntity) {
        self.title = boardEntity.title ?? "정보가 없습니다."
        self.info = boardEntity.info ?? ""
        self.moves = boardEntity.moves?.map { MoveModel(moveEntity: $0) } ?? []
    }
    
    init() {
        self.title = "정보가 없습니다."
        self.info = ""
        self.moves = []
    }
}

struct MoveModelForEdit {
    var pgn: String
    var type: MoveType
    var title: String
    var info: String
    var valid: Bool
    init(moveModel: BoardModel.MoveModel) {
        self.pgn = moveModel.pgn
        self.type = moveModel.type
        self.title = moveModel.title
        self.info = moveModel.info
        self.valid = true
    }
    init(pgn: String) {
        self.pgn = pgn
        self.type = .mainbook
        self.title = ""
        self.info = ""
        self.valid = false
    }
}
