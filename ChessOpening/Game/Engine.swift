//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    var pgn: String = ""
    
    let EMPTY: Int = 0
    let WHITE: Int = 1
    let BLACK: Int = 2
    
    var turn: Int = 0
    
    // (White King Side, White Queen Side, Black King Side, Black Queen Side)
    var castling: (Bool, Bool, Bool, Bool) = (true, true, true, true)
    var enpassant: Int = -1
    
    
    var board: [[Piece]] = []
    
    init() {
        board = [
            [Rook(engine: self, color: BLACK), Knight(engine: self, color: BLACK), Bishop(engine: self, color: BLACK), Queen(engine: self, color: BLACK), King(engine: self, color: BLACK), Bishop(engine: self, color: BLACK), Knight(engine: self, color: BLACK), Rook(engine: self, color: BLACK)],
            [Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK), Pawn(engine: self, color: BLACK)],
            [Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self)],
            [Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self)],
            [Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self)],
            [Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self), Empty(engine: self)],
            [Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE), Pawn(engine: self, color: WHITE)],
            [Rook(engine: self, color: WHITE), Knight(engine: self, color: WHITE), Bishop(engine: self, color: WHITE), Queen(engine: self, color: WHITE), King(engine: self, color: WHITE), Bishop(engine: self, color: WHITE), Knight(engine: self, color: WHITE), Rook(engine: self, color: WHITE)]
        ]
    }
    
    init(pgn: String) {
        
    }
    
    init(fen: String) {
        // 체스판 턴 캐슬링 앙파상 50수 몇턴째
        // rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3
        
        
    }
    
    func movePiece(move: ((Int, Int), (Int, Int))) {
        
    }
    
    func isLegalMove(move: ((Int, Int), (Int, Int))) -> Bool {
        var movedBoard = board
        movedBoard[move.1.0][move.1.1] = board[move.0.0][move.0.1]
        movedBoard[move.0.0][move.0.1] = Empty(engine: self)
        
        for i in 0..<8 {
            for j in 0..<8 {
                for move in movedBoard[i][j].getMove(x: i, y: j) {
                    if movedBoard[move.0][move.1] is King && movedBoard[move.0][move.1].color == turn {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func isValidCoordinate(x: Int, y: Int) -> Bool {
        if x < 0 || x > 7 || y < 0 || y > 7 {
            return false
        }
        return true
    }
    func isValidCoordinate(coordinate: (Int, Int)) -> Bool {
        let x = coordinate.0
        let y = coordinate.1
        if x < 0 || x > 7 || y < 0 || y > 7 {
            return false
        }
        return true
    }
    
    func getColor(coordinate: (Int, Int)) -> Int {
        return board[coordinate.0][coordinate.1].color
    }
    func getColor(x: Int, y: Int) -> Int {
        return board[x][y].color
    }
    
}
