//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    var pgn: String = ""
    
    static let EMPTY: Int = -1
    static let WHITE: Int = 0
    static let BLACK: Int = 1
    
    var turn: Int = 0
    
    var castling: (white: (kingSide: Bool, queenSide: Bool), black: (kingSide: Bool, queenSide: Bool)) = ((true, true), (true, true))
    var enpassant: Int = -1
    
    
    var board: [[Piece]] = []
    
    var legalMoves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
    
    init() {
        print("hihi")
        board = [
            [Rook(color: Engine.BLACK), Knight(color: Engine.BLACK), Bishop(color: Engine.BLACK), Queen(color: Engine.BLACK), King(color: Engine.BLACK), Bishop(color: Engine.BLACK), Knight(color: Engine.BLACK), Rook(color: Engine.BLACK)],
            [Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK), Pawn(color: Engine.BLACK)],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE), Pawn(color: Engine.WHITE)],
            [Rook(color: Engine.WHITE), Knight(color: Engine.WHITE), Bishop(color: Engine.WHITE), Queen(color: Engine.WHITE), King(color: Engine.WHITE), Bishop(color: Engine.WHITE), Knight(color: Engine.WHITE), Rook(color: Engine.WHITE)]
        ]
        getLegalMoves()
    }
    
    init(pgn: String) {
        
    }
    
    init(fen: String) {
        // 체스판 턴 캐슬링 앙파상 50수 몇턴째
        // rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3
        
        
    }
    
    func getKingCoordinate(board: [[Piece]], color: Int) -> (rank: Int, file: Int)? {
        for r in 0..<8 {
            for f in 0..<8 {
                if board[r][f] is King && board[r][f].color == color {
                    return (r, f)
                }
            }
        }
        return nil
    }
    
    func movePiece(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) {
        // 캐슬링 앙파상 등
        turn += 1
//        board[move.from.rank][move.from.file]
        // pgn
        board[move.to.rank][move.to.file] = board[move.from.rank][move.from.file]
        board[move.from.rank][move.from.file] = Empty()
        
        getLegalMoves()
    }
    
    func isLegalMove(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) -> Bool {
        return legalMoves.contains(where: { return $0.from == move.from && $0.to == move.to })
    }
    
    func isAttacked(board: [[Piece]], coordinate: (rank: Int, file: Int), turn: Int) -> Bool {
        for r in 0..<8 {
            for f in 0..<8 {
                if board[r][f].color == turn {
                    for attack in board[r][f].getMove(board: board, rank: r, file: f) {
                        if attack == coordinate {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func getLegalMoves() {
        legalMoves.removeAll()
        for r in 0..<8 {
            for f in 0..<8 {
                if board[r][f].color == turn%2 {
                    for move in board[r][f].getMove(board: board, rank: r, file: f) {
                        var testBoard = board
                        testBoard[move.rank][move.file] = testBoard[r][f]
                        testBoard[r][f] = Empty()
                        guard let kingCoordinate = getKingCoordinate(board: testBoard, color: turn%2) else {
                            continue
                        }
                        if !isAttacked(board: testBoard, coordinate: kingCoordinate, turn: (turn+1)%2) {
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
