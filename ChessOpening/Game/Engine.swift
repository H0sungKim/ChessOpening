//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    var pgn: String = ""
    
    let WHITE: Int = 0
    let BLACK: Int = 1
    
    var turn: Int = 0
    
    var castling: (whiteKingSide: Bool, whiteQueenSide: Bool, blackKingSide: Bool, blackQueenSide: Bool) = (true, true, true, true)
    var enpassant: Int = -1
    
    
    var board: [[Piece]] = []
    
    var legalMoves: [(from: (row: Int, column: Int), to: (row: Int, column: Int))] = []
    
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
    
    func getLegalMoves() {
        for r in 0..<8 {
            for c in 0..<8 {
                if board[r][c].color == turn%2 {
                    
                }
            }
        }
    }
    
    func isValidCoordinate(row: Int, column: Int) -> Bool {
        if row < 0 || row > 7 || column < 0 || column > 7 {
            return false
        }
        return true
    }
    func isValidCoordinate(coordinate: (row: Int, column: Int)) -> Bool {
        let row = coordinate.row
        let column = coordinate.column
        if row < 0 || row > 7 || column < 0 || column > 7 {
            return false
        }
        return true
    }
    
    func getColor(coordinate: (row: Int, column: Int)) -> Int {
        return board[coordinate.row][coordinate.column].color
    }
    func getColor(row: Int, column: Int) -> Int {
        return board[row][column].color
    }
    
}
