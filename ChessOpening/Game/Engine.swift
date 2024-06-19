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
        getLegalMoves()
        print(legalMoves)
    }
    
    init(pgn: String) {
        
    }
    
    init(fen: String) {
        // 체스판 턴 캐슬링 앙파상 50수 몇턴째
        // rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3
        
        
    }
    
    func movePiece(move: (from: (row: Int, column: Int), to: (row: Int, column: Int))) -> Bool {
        if !(legalMoves.contains(where: { return $0.from == move.from && $0.to == move.to })) {
            return false
        }
        
        
        
        // 캐슬링 앙파상 등
        // pgn
        board[move.to.row][move.to.column] = board[move.from.row][move.from.column]
        board[move.from.row][move.from.column] = Empty(engine: self)
        return true
    }
    
    func isLegalMove(move: (from: (row: Int, column: Int), to: (row: Int, column: Int))) -> Bool {
        var movedBoard = board
        let pieceColor = board[move.from.row][move.from.column].color
        movedBoard[move.to.row][move.to.column] = board[move.from.row][move.from.column]
        movedBoard[move.from.row][move.from.column] = Empty(engine: self)
        
        for r in 0..<8 {
            for c in 0..<8 {
                if board[r][c].color != pieceColor {
                    for attack in movedBoard[r][c].getMove(row: r, column: c) {
                        if movedBoard[attack.row][attack.column] is King && movedBoard[attack.row][attack.column].color == pieceColor {
                            return false
                        }
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
                    for move in board[r][c].getMove(row: r, column: c) {
                        if isLegalMove(move: (from: (r, c), to: move)) {
                            legalMoves.append((from: (r, c), to: move))
                        }
                    }
                    
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
