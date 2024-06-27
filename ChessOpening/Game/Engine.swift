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
    var enpassant: Int?
    
    
    var board: [[Piece]] = []
    
    var legalMoves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
    
    init() {
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
        legalMoves = getLegalMoves()
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
    
    func isCheck(board: [[Piece]], kingColor: Int) -> Bool {
        guard let kingCoordinate = getKingCoordinate(board: board, color: kingColor) else {
            return false
        }
        return isAttacked(board: board, coordinate: kingCoordinate, turn: abs(kingColor-1))
    }
    
    func movePiece(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) {
        if let enpassant = enpassant {
            if board[move.from.rank][move.from.file] is Pawn && move.to.rank == 2+3*(turn%2) && move.to.file == enpassant {
                board[move.from.rank][enpassant] = Empty()
            }
        }
        enpassant = nil
        // enpassant
        if board[move.from.rank][move.from.file] is Pawn && abs(move.to.rank-move.from.rank) == 2 && ((board[move.to.rank][move.to.file-1] is Pawn && board[move.to.rank][move.to.file-1].color != turn%2) || (board[move.to.rank][move.to.file+1] is Pawn && board[move.to.rank][move.to.file+1].color != turn%2)) {
            enpassant = move.from.file
        }
        // castling
        if board[move.from.rank][move.from.file] is King {
            if move.to.file-move.from.file == 2 {
                board[7-turn%2*7][5] = board[7-turn%2*7][7]
                board[7-turn%2*7][7] = Empty()
            } else if move.to.file-move.from.file == -2 {
                board[7-turn%2*7][3] = board[7-turn%2*7][0]
                board[7-turn%2*7][0] = Empty()
            }
            if turn%2 == Engine.WHITE {
                castling.white = (false, false)
            } else {
                castling.black = (false, false)
            }
        }
        if board[move.from.rank][move.from.file] is Rook {
            if move.from.rank == 7-turn%2*7 {
                if move.from.file == 0 {
                    if turn%2 == Engine.WHITE {
                        castling.white.queenSide = false
                    } else {
                        castling.black.queenSide = false
                    }
                } else if move.from.file == 7 {
                    if turn%2 == Engine.WHITE {
                        castling.white.kingSide = false
                    } else {
                        castling.black.kingSide = false
                    }
                }
            }
        }
        turn += 1
        board[move.to.rank][move.to.file] = board[move.from.rank][move.from.file]
        board[move.from.rank][move.from.file] = Empty()
        
        legalMoves = getLegalMoves()
        // 메이트 확인
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
    
    func getLegalMoves() -> [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] {
        var moves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
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
                            moves.append((from: (r, f), to: move))
                        }
                    }
                }
            }
        }
        moves.append(contentsOf: getCastlingMoves())
        moves.append(contentsOf: getEnpassantMoves())
        return moves
    }
    
    func getEnpassantMoves() -> [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] {
        var moves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
        if let enpassant = enpassant {
            let direction = 2 * (turn%2) - 1
            let coordinate = (rank: 3+turn%2,file: enpassant)
            if isValidCoordinate(coordinate: (coordinate.rank, coordinate.file-1)) && board[coordinate.rank][coordinate.file-1] is Pawn && board[coordinate.rank][coordinate.file-1].color == turn%2 {
                moves.append((from: (coordinate.rank, coordinate.file-1), to: (coordinate.rank+direction, coordinate.file)))
            }
            if isValidCoordinate(coordinate: (coordinate.rank, coordinate.file+1)) && board[coordinate.rank][coordinate.file+1] is Pawn && board[coordinate.rank][coordinate.file+1].color == turn%2 {
                moves.append((from: (coordinate.rank, coordinate.file+1), to: (coordinate.rank+direction, coordinate.file)))
            }
        }
        return moves
    }
    
    func getCastlingMoves() -> [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] {
        var moves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
        var castling: (kingSide: Bool, queenSide: Bool)
        if turn%2 == Engine.WHITE {
            castling = self.castling.white
        } else {
            castling = self.castling.black
        }
        if castling.kingSide {
            if board[7-turn%2*7][5] is Empty && board[7-turn%2*7][6] is Empty && !(isAttacked(board: board, coordinate: (7-turn%2*7, 4), turn: abs(turn%2-1))) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 5), turn: abs(turn%2-1))) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 6), turn: abs(turn%2-1))) {
                moves.append(((7-turn%2*7, 4), (7-turn%2*7, 6)))
            }
        }
        if castling.queenSide {
            if board[7-turn%2*7][1] is Empty && board[7-turn%2*7][2] is Empty && board[7-turn%2*7][3] is Empty && !(isAttacked(board: board, coordinate: (7-turn%2*7, 4), turn: abs(turn%2-1))) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 3), turn: abs(turn%2-1))) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 2), turn: abs(turn%2-1))) {
                moves.append(((7-turn%2*7, 4), (7-turn%2*7, 2)))
            }
        }
        return moves
    }
}
