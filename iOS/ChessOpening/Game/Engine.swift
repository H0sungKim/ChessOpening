//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    var pgn: [String] = []
    var fen: [String] = []
    
    static let EMPTY: Int = -1
    static let WHITE: Int = 0
    static let BLACK: Int = 1
    
    var turn: Int = 0
    var moveCount50: Int = 0
    
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
        fen.append(getFEN())
        legalMoves = getLegalMoves()
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
    
    func getPGNWithoutCheck(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int)), promotionPiece: Piece.Type? = nil) -> String {
        var pgn = ""
        switch type(of: board[move.from.rank][move.from.file]) {
        case is Empty.Type:
            return ""
        case is Pawn.Type:
            if (move.to.rank == 2+3*(turn%2) && move.to.file == enpassant) ||
                !(board[move.to.rank][move.to.file] is Empty)
            {
                pgn.append("\(Engine.convertFileIntToString(file: move.from.file))x")
            }
        case is King.Type:
            if move.to.file-move.from.file == 2 {
                return "0-0"
            } else if move.to.file-move.from.file == -2 {
                return "0-0-0"
            }
        default:
            pgn.append(type(of: board[move.from.rank][move.from.file]).getString(color: Engine.WHITE))
            if legalMoves.contains(where: {
                $0.to == move.to &&
                type(of: board[move.from.rank][move.from.file]) == type(of: board[$0.from.rank][$0.from.file]) &&
                $0.from != move.from
            }) {
                pgn.append(Engine.convertFileIntToString(file: move.from.file))
            }
            if !(board[move.to.rank][move.to.file] is Empty) {
                pgn.append("x")
            }
        }
        pgn.append("\(Engine.convertFileIntToString(file: move.to.file))\(8-move.to.rank)")
        if let promotionPiece = promotionPiece {
            pgn.append("=\(promotionPiece.getString(color: Engine.WHITE))")
        }
        return pgn
    }
    
    func applyMove(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int)), promotionPiece: Piece.Type? = nil) {
        var pgn = getPGNWithoutCheck(move: move, promotionPiece: promotionPiece)
        if board[move.from.rank][move.from.file] is Pawn || pgn.contains("x") {
            moveCount50 = 0
        } else {
            moveCount50 += 1
        }
        if let enpassant = enpassant,
           board[move.from.rank][move.from.file] is Pawn &&
            move.to.rank == 2+3*(turn%2) &&
            move.to.file == enpassant
        {
            board[move.from.rank][enpassant] = Empty()
        }
        enpassant = nil
        // enpassant
        if board[move.from.rank][move.from.file] is Pawn &&
            abs(move.to.rank-move.from.rank) == 2 &&
            ((board[move.to.rank][move.to.file-1] is Pawn && board[move.to.rank][move.to.file-1].color != turn%2) || (board[move.to.rank][move.to.file+1] is Pawn && board[move.to.rank][move.to.file+1].color != turn%2))
        {
            enpassant = move.from.file
        }
        // castling
        if board[move.from.rank][move.from.file] is King {
            switch move.to.file-move.from.file {
            case -2:
                board[7-turn%2*7][3] = board[7-turn%2*7][0]
                board[7-turn%2*7][0] = Empty()
            case 2:
                board[7-turn%2*7][5] = board[7-turn%2*7][7]
                board[7-turn%2*7][7] = Empty()
            default:
                break
            }
            turn%2 == Engine.WHITE ? (castling.white = (false, false)) : (castling.black = (false, false))
        }
        if board[move.from.rank][move.from.file] is Rook && move.from.rank == 7 - turn % 2 * 7 {
            switch move.from.file {
            case 0:
                turn % 2 == Engine.WHITE ? (castling.white.queenSide = false) : (castling.black.queenSide = false)
            case 7:
                turn % 2 == Engine.WHITE ? (castling.white.kingSide = false) : (castling.black.kingSide = false)
            default:
                break
            }
        }
        
        if let promotionPiece = promotionPiece {
            board[move.to.rank][move.to.file] = promotionPiece.init(color: turn%2)
        } else {
            board[move.to.rank][move.to.file] = board[move.from.rank][move.from.file]
        }
        board[move.from.rank][move.from.file] = Empty()
        turn += 1
        legalMoves = getLegalMoves()
        if isCheck(board: board, kingColor: turn%2) {
            legalMoves.isEmpty ? pgn.append("#") : pgn.append("+")
        }
        self.pgn = Array(self.pgn.prefix(turn-1))
        self.pgn.append(pgn)
        fen = Array(fen.prefix(turn))
        fen.append(getFEN())
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
            if Util.shared.isValidCoordinate(coordinate: (coordinate.rank, coordinate.file-1)) && board[coordinate.rank][coordinate.file-1] is Pawn && board[coordinate.rank][coordinate.file-1].color == turn%2 {
                moves.append((from: (coordinate.rank, coordinate.file-1), to: (coordinate.rank+direction, coordinate.file)))
            }
            if Util.shared.isValidCoordinate(coordinate: (coordinate.rank, coordinate.file+1)) && board[coordinate.rank][coordinate.file+1] is Pawn && board[coordinate.rank][coordinate.file+1].color == turn%2 {
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
    
    func getFEN() -> String {
        // 체스판 턴 캐슬링 앙파상 50수 몇턴째
        // FEN
        // rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3
        var fen = ""
        var emptyCount = 0
        for r in 0..<8 {
            for f in 0..<8 {
                if board[r][f] is Empty {
                    emptyCount += 1
                } else {
                    if emptyCount != 0 {
                        fen.append("\(emptyCount)")
                        emptyCount = 0
                    }
                    fen.append(board[r][f].getString())
                }
            }
            if emptyCount != 0 {
                fen.append("\(emptyCount)")
                emptyCount = 0
            }
            fen.append("/")
        }
        fen.removeLast()
        fen.append(turn%2==0 ? " w " : " b ")
        if castling.white.kingSide {
            fen.append("K")
        }
        if castling.white.queenSide {
            fen.append("Q")
        }
        if castling.black.kingSide {
            fen.append("k")
        }
        if castling.black.queenSide {
            fen.append("q")
        }
        if !(castling.white.kingSide || castling.white.queenSide || castling.black.kingSide || castling.black.queenSide) {
            fen.append("-")
        }
        if let enpassant = enpassant {
            fen.append("\(Engine.convertFileIntToString(file: enpassant))\(6-turn%2*3)")
        } else {
            fen.append(" - ")
        }
        fen.append("\(moveCount50) \(turn/2+1)")
        
        return fen
    }
    
    func getSimpleFEN(fen: String) -> String {
        var parts = fen.split(separator: " ")
        parts.removeLast()
        parts.removeLast()
        return parts.joined(separator: " ")
    }
    
    func getSimpleFEN() -> String {
        let fen = getFEN()
        var parts = fen.split(separator: " ")
        parts.removeLast()
        parts.removeLast()
        return parts.joined(separator: " ")
    }
    func applyFEN(fen: String) {
        // rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3
        let fenArray = fen.split(separator: " ")
        let fenBoard = fenArray[0].split(separator: "/")
        for r in 0..<8 {
            var rank: [Piece] = []
            for f in fenBoard[r] {
                if let emptyCount = f.wholeNumberValue {
                    for _ in 0..<emptyCount {
                        rank.append(Empty())
                    }
                } else {
                    rank.append(Engine.charToPiece(char: f))
                }
            }
            board[r] = rank
        }
        if fenArray[2].contains("K") {
            castling.white.kingSide = true
        }
        if fenArray[2].contains("Q") {
            castling.white.queenSide = true
        }
        if fenArray[2].contains("k") {
            castling.black.kingSide = true
        }
        if fenArray[2].contains("q") {
            castling.black.queenSide = true
        }
        enpassant = Engine.convertFileStringToInt(file: String(fenArray[3].prefix(1)))
        moveCount50 = Int(fenArray[4])!
        turn = (fenArray[1] == "w" ? Int(fenArray[5])!*2-2 : Int(fenArray[5])!*2-1)
        
        legalMoves = getLegalMoves()
    }
    
    static func charToPiece(char: Character) -> Piece {
        switch char {
        case "K" :
            return King(color: Engine.WHITE)
        case "k" :
            return King(color: Engine.BLACK)
        case "Q" :
            return Queen(color: Engine.WHITE)
        case "q" :
            return Queen(color: Engine.BLACK)
        case "R" :
            return Rook(color: Engine.WHITE)
        case "r" :
            return Rook(color: Engine.BLACK)
        case "B" :
            return Bishop(color: Engine.WHITE)
        case "b" :
            return Bishop(color: Engine.BLACK)
        case "N" :
            return Knight(color: Engine.WHITE)
        case "n" :
            return Knight(color: Engine.BLACK)
        case "P" :
            return Pawn(color: Engine.WHITE)
        case "p" :
            return Pawn(color: Engine.BLACK)
        default :
            return Empty()
        }
    }
    
    static func convertFileIntToString(file: Int) -> String {
        switch file {
        case 0 :
            return "a"
        case 1 :
            return "b"
        case 2 :
            return "c"
        case 3 :
            return "d"
        case 4 :
            return "e"
        case 5 :
            return "f"
        case 6 :
            return "g"
        case 7 :
            return "h"
        default :
            return ""
        }
    }
    static func convertFileStringToInt(file: String) -> Int? {
        switch file {
        case "a" :
            return 0
        case "b" :
            return 1
        case "c" :
            return 2
        case "d" :
            return 3
        case "e" :
            return 4
        case "f" :
            return 5
        case "g" :
            return 6
        case "h" :
            return 7
        default :
            return nil
        }
    }
    
    func getTurn() -> String {
        return turn%2 == 0 ? "\(turn/2+1)." : "\(turn/2+1)..."
    }
    
    func convertPGNtoCoordinate(pgn: String) -> (move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int)), promotion: Piece.Type?)? {
//        e4 Re4 Rxe4 Rhe4 0-0-0 e8=Q
        let pgnRegex = /^([KQRBN])?([a-h])?(x)?([a-h])([1-8])(=)?([QRBN])?([+#])?$/
        
        guard let match = pgn.wholeMatch(of: pgnRegex) else {
            return nil
        }
        let (matchPGN, matchPiece, matchPieceFile, matchTake, matchFile, matchRank, matchPromotion, matchPromotionPiece, matchCheck) = match.output
        let piece: Piece.Type
        if let matchPiece = matchPiece {
            piece = type(of: Engine.charToPiece(char: matchPiece.first!))
        } else {
            piece = Pawn.self
        }
        let promotionPiece: Piece.Type?
        if let _ = matchPromotion, let matchPromotionPiece = matchPromotionPiece {
            promotionPiece = type(of: Engine.charToPiece(char: matchPromotionPiece.first!))
        } else {
            promotionPiece = nil
        }
        
        guard let matchRank = Int(String(matchRank)) else {
            return nil
        }
        guard let matchFile = Engine.convertFileStringToInt(file: String(matchFile)) else {
            return nil
        }
        let to: (rank: Int, file: Int) = (rank: matchRank, file: matchFile)
        
        for legalMove in legalMoves {
            if legalMove.to == to
                && type(of: board[legalMove.from.rank][legalMove.from.file]) == piece {
                guard let matchPieceFile = Engine.convertFileStringToInt(file: String(matchPieceFile ?? "")) else {
                    return (move: (from: legalMove.from, to: legalMove.to), promotion: promotionPiece)
                }
                if matchPieceFile == legalMove.from.file {
                    return (move: (from: legalMove.from, to: legalMove.to), promotion: promotionPiece)
                }
            }
        }
        return nil
    }
}

