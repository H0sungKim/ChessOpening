//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    var pgn: String = ""
    
    let EMPTY: Int = -1
    let WHITE: Int = 0
    let BLACK: Int = 1
    
    var turn: Int = 0
    
    var castling: (white: (kingSide: Bool, queenSide: Bool), black: (kingSide: Bool, queenSide: Bool)) = ((true, true), (true, true))
    var enpassant: Int = -1
    
    
    var board: [[Piece]] = []
    
    var legalMoves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
    
    init() {
        print("hihi")
        board = [
            [Rook(color: BLACK), Knight(color: BLACK), Bishop(color: BLACK), Queen(color: BLACK), King(color: BLACK), Bishop(color: BLACK), Knight(color: BLACK), Rook(color: BLACK)],
            [Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK)],
            [Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY)],
            [Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY)],
            [Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY)],
            [Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY), Empty(color: EMPTY)],
            [Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE)],
            [Rook(color: WHITE), Knight(color: WHITE), Bishop(color: WHITE), Queen(color: WHITE), King(color: WHITE), Bishop(color: WHITE), Knight(color: WHITE), Rook(color: WHITE)]
        ]
        getLegalMoves()
    }
    
    init(pgn: String) {
        
    }
    
    init(fen: String) {
        // 체스판 턴 캐슬링 앙파상 50수 몇턴째
        // rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3
        
        
    }
    
    func movePiece(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) {
        // 캐슬링 앙파상 등
        turn += 1
        board[move.from.rank][move.from.file]
        // pgn
        board[move.to.rank][move.to.file] = board[move.from.rank][move.from.file]
        board[move.from.rank][move.from.file] = Empty(color: EMPTY)
    }
    
    func isLegalMove(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) -> Bool {
        return legalMoves.contains(where: { return $0.from == move.from && $0.to == move.to })
    }
    
    func isAttacked(board: [[Piece]], coordinate: (rank: Int, file: Int), turn: Int) -> Bool {
        for r in 0..<8 {
            for f in 0..<8 {
                if board[r][f].color == turn {
                    for attack in board[r][f].getMove(rank: r, file: f) {
                        if movedBoard[attack.rank][attack.file] is King && movedBoard[attack.rank][attack.file].color == pieceColor {
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
            for f in 0..<8 {
                if board[r][f].color == turn%2 {
                    for move in board[r][f].getMove(rank: r, file: f) {
                        if checkMove(move: (from: (r, f), to: move)) {
                            legalMoves.append((from: (r, f), to: move))
                        }
                    }
                    
                }
            }
        }
        // castling
        // 바꾸기 전 킹 룩 사이 비어있는지 공격당하는지, 체크인지
    }
    
    
}
