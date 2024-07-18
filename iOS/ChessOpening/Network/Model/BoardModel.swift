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

struct BoardModel {
    var title: String
    var info: String
    var moves: [MoveModel]
    
    struct MoveModel {
        var pgn: String
        var type: Int
        var title: String
        var info: String
        init(moveEntity: BoardEntity.BoardResponseDataEntity.MoveEntity) {
            self.pgn = moveEntity.pgn ?? ""
            self.type = moveEntity.type ?? 0
            self.title = moveEntity.title ?? ""
            self.info = moveEntity.info ?? ""
        }
    }
    
    init(boardEntity: BoardEntity.BoardResponseDataEntity) {
        self.title = boardEntity.title ?? ""
        self.info = boardEntity.info ?? ""
        self.moves = boardEntity.moves?.map { MoveModel(moveEntity: $0) } ?? []
    }
}
