//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    enum Color: Int {
        case empty = -1
        case white = 0
        case black = 1
        
        func getOpposite() -> Color {
            switch self {
            case .empty:
                return .empty
            case .white:
                return .black
            case .black:
                return .white
            }
        }
    }
    var pgn: [String] = []
    var fen: [String] = []
    
    var turn: Int = 0
    var moveCount50: Int = 0
    
    var castling: (white: (kingSide: Bool, queenSide: Bool), black: (kingSide: Bool, queenSide: Bool)) = ((true, true), (true, true))
    var enpassant: Int?
    
    var board: [[Piece]] = []
    
    var legalMoves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
    
    init() {
        board = [
            [Rook(color: .black), Knight(color: .black), Bishop(color: .black), Queen(color: .black), King(color: .black), Bishop(color: .black), Knight(color: .black), Rook(color: .black)],
            [Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black)],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
            [Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white)],
            [Rook(color: .white), Knight(color: .white), Bishop(color: .white), Queen(color: .white), King(color: .white), Bishop(color: .white), Knight(color: .white), Rook(color: .white)]
        ]
        fen.append(getFEN())
        legalMoves = getLegalMoves()
    }
    
    init(engine: Engine) {
        self.pgn = engine.pgn
        self.fen = engine.fen
        self.turn = engine.turn
        self.moveCount50 = engine.moveCount50
        self.castling = engine.castling
        self.enpassant = engine.enpassant
        self.board = engine.board
        self.legalMoves = engine.legalMoves
    }
    
    init(fen: String) {
        applyFEN(fen: fen)
        self.fen.append(fen)
    }
    
    func getKingCoordinate(board: [[Piece]], color: Color) -> (rank: Int, file: Int)? {
        for r in 0..<8 {
            for f in 0..<8 {
                if board[r][f] is King && board[r][f].color == color {
                    return (r, f)
                }
            }
        }
        return nil
    }
    
    func isCheck(board: [[Piece]], kingColor: Color) -> Bool {
        guard let kingCoordinate = getKingCoordinate(board: board, color: kingColor) else {
            return false
        }
        return isAttacked(board: board, coordinate: kingCoordinate, turn: kingColor.getOpposite())
    }
    
    func getPGNWithoutCheck(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int)), promotionPiece: Piece.Type? = nil) -> String {
        var pgn = ""
        if board[move.from.rank][move.from.file] is King {
            if move.to.file-move.from.file == 2 {
                return "O-O"
            } else if move.to.file-move.from.file == -2 {
                return "O-O-O"
            }
        }
        switch type(of: board[move.from.rank][move.from.file]) {
        case is Empty.Type:
            return ""
        case is Pawn.Type:
            if (move.to.rank == 2+3*(turn%2) && move.to.file == enpassant) ||
                !(board[move.to.rank][move.to.file] is Empty)
            {
                pgn.append("\(Util.shared.convertFileIntToString(file: move.from.file))x")
            }
        default:
            pgn.append(type(of: board[move.from.rank][move.from.file]).getString(color: .white))
            var containOverlap = false
            var isFileOverlap = false
            var isRankOverlap = false
            for legalMove in legalMoves {
                if legalMove.to == move.to &&
                    type(of: board[move.from.rank][move.from.file]) == type(of: board[legalMove.from.rank][legalMove.from.file]) &&
                    legalMove.from != move.from {
                    containOverlap = true
                    if legalMove.from.file == move.from.file {
                        isFileOverlap = true
                    }
                    if legalMove.from.rank == move.from.rank {
                        isRankOverlap = true
                    }
                }
            }
            if containOverlap {
                if isFileOverlap {
                    if isRankOverlap {
                        pgn.append(Util.shared.convertFileIntToString(file: move.from.file))
                    }
                    pgn.append(String(8-move.from.rank))
                } else {
                    pgn.append(Util.shared.convertFileIntToString(file: move.from.file))
                }
            }
            if !(board[move.to.rank][move.to.file] is Empty) {
                pgn.append("x")
            }
        }
        pgn.append("\(Util.shared.convertFileIntToString(file: move.to.file))\(8-move.to.rank)")
        if let promotionPiece = promotionPiece {
            pgn.append("=\(promotionPiece.getString(color: .white))")
        }
        return pgn
    }
    
    func getLegalMovesPGN() -> [String] {
        var pgns: [String] = []
        
        for legalMove in legalMoves {
            if board[legalMove.from.rank][legalMove.from.file] is Pawn && legalMove.to.rank == turn%2*7 {
                for promotionPiece in [Queen.self, Rook.self, Bishop.self, Knight.self] {
                    var pgn = getPGNWithoutCheck(move: legalMove, promotionPiece: promotionPiece as? any Piece.Type)
                    let tempEngine = Engine(engine: self)
                    tempEngine.applyMove(move: legalMove, promotionPiece: promotionPiece as? any Piece.Type)
                    if tempEngine.isCheck(board: tempEngine.board, kingColor: Color(rawValue: tempEngine.turn%2)!) {
                        tempEngine.legalMoves.isEmpty ? pgn.append("#") : pgn.append("+")
                    }
                    pgns.append(pgn)
                }
            } else {
                var pgn = getPGNWithoutCheck(move: legalMove)
                let tempEngine = Engine(engine: self)
                tempEngine.applyMove(move: legalMove)
                if tempEngine.isCheck(board: tempEngine.board, kingColor: Color(rawValue: tempEngine.turn%2)!) {
                    tempEngine.legalMoves.isEmpty ? pgn.append("#") : pgn.append("+")
                }
                pgns.append(pgn)
            }
        }
        return pgns
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
            ((Util.shared.isValidCoordinate(coordinate: (move.to.rank, move.to.file-1)) && board[move.to.rank][move.to.file-1] is Pawn && board[move.to.rank][move.to.file-1].color.rawValue != turn%2) || (Util.shared.isValidCoordinate(coordinate: (move.to.rank, move.to.file+1)) && board[move.to.rank][move.to.file+1] is Pawn && board[move.to.rank][move.to.file+1].color.rawValue != turn%2))
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
            turn%2 == Color.white.rawValue ? (castling.white = (false, false)) : (castling.black = (false, false))
        }
        if board[move.from.rank][move.from.file] is Rook && move.from.rank == 7 - turn % 2 * 7 {
            switch move.from.file {
            case 0:
                turn % 2 == Color.white.rawValue ? (castling.white.queenSide = false) : (castling.black.queenSide = false)
            case 7:
                turn % 2 == Color.white.rawValue ? (castling.white.kingSide = false) : (castling.black.kingSide = false)
            default:
                break
            }
        }
        
        if let promotionPiece = promotionPiece {
            board[move.to.rank][move.to.file] = promotionPiece.init(color: Color(rawValue: turn%2)!)
        } else {
            board[move.to.rank][move.to.file] = board[move.from.rank][move.from.file]
        }
        board[move.from.rank][move.from.file] = Empty()
        turn += 1
        legalMoves = getLegalMoves()
        if isCheck(board: board, kingColor: Color(rawValue: turn%2)!) {
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
    
    func isAttacked(board: [[Piece]], coordinate: (rank: Int, file: Int), turn: Color) -> Bool {
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
                if board[r][f].color.rawValue == turn%2 {
                    for move in board[r][f].getMove(board: board, rank: r, file: f) {
                        var testBoard = board
                        testBoard[move.rank][move.file] = testBoard[r][f]
                        testBoard[r][f] = Empty()
                        guard let kingCoordinate = getKingCoordinate(board: testBoard, color: Color(rawValue: turn%2)!) else {
                            continue
                        }
                        if !isAttacked(board: testBoard, coordinate: kingCoordinate, turn: Color(rawValue: (turn+1)%2)!) {
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
            if Util.shared.isValidCoordinate(coordinate: (coordinate.rank, coordinate.file-1)) && board[coordinate.rank][coordinate.file-1] is Pawn && board[coordinate.rank][coordinate.file-1].color.rawValue == turn%2 {
                moves.append((from: (coordinate.rank, coordinate.file-1), to: (coordinate.rank+direction, coordinate.file)))
            }
            if Util.shared.isValidCoordinate(coordinate: (coordinate.rank, coordinate.file+1)) && board[coordinate.rank][coordinate.file+1] is Pawn && board[coordinate.rank][coordinate.file+1].color.rawValue == turn%2 {
                moves.append((from: (coordinate.rank, coordinate.file+1), to: (coordinate.rank+direction, coordinate.file)))
            }
        }
        return moves
    }
    
    func getCastlingMoves() -> [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] {
        var moves: [(from: (rank: Int, file: Int), to: (rank: Int, file: Int))] = []
        var castling: (kingSide: Bool, queenSide: Bool)
        if turn%2 == Color.white.rawValue {
            castling = self.castling.white
        } else {
            castling = self.castling.black
        }
        if castling.kingSide {
            if board[7-turn%2*7][5] is Empty && board[7-turn%2*7][6] is Empty && !(isAttacked(board: board, coordinate: (7-turn%2*7, 4), turn: Color.init(rawValue: turn%2)!.getOpposite())) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 5), turn: Color.init(rawValue: turn%2)!.getOpposite())) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 6), turn: Color.init(rawValue: turn%2)!.getOpposite())) {
                moves.append(((7-turn%2*7, 4), (7-turn%2*7, 6)))
            }
        }
        if castling.queenSide {
            if board[7-turn%2*7][1] is Empty && board[7-turn%2*7][2] is Empty && board[7-turn%2*7][3] is Empty && !(isAttacked(board: board, coordinate: (7-turn%2*7, 4), turn: Color.init(rawValue: turn%2)!.getOpposite())) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 3), turn: Color.init(rawValue: turn%2)!.getOpposite())) && !(isAttacked(board: board, coordinate: (7-turn%2*7, 2), turn: Color.init(rawValue: turn%2)!.getOpposite())) {
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
        fen.append(" ")
        if let enpassant = enpassant {
            fen.append("\(Util.shared.convertFileIntToString(file: enpassant))\(6-turn%2*3)")
        } else {
            fen.append("-")
        }
        fen.append(" ")
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
//        rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1
//        (
//            "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1",
//            "rnbqkbnr",
//            "pppppppp",
//            "8",
//            "8",
//            "4P3",
//            "8",
//            "PPPP1PPP",
//            "RNBQKBNR",
//            "b",
//            "KQkq",
//            "-",
//            "0",
//            "1"
//        )
        
        let pgnRegex = /^([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8})\/([KQRBNPkqrbnp1-8]{1, 8}) (w|b) (K?Q?k?q?|-) ([a-h][1-8]|-) ?(\d+)? ?(\d+)?$/
        
        guard let match = fen.wholeMatch(of: pgnRegex) else {
            return
        }
        board = []
        let fenBoard = [
            match.output.1,
            match.output.2,
            match.output.3,
            match.output.4,
            match.output.5,
            match.output.6,
            match.output.7,
            match.output.8,
        ]
        for r in 0..<8 {
            var rank: [Piece] = []
            for f in fenBoard[r] {
                if let emptyCount = f.wholeNumberValue {
                    for _ in 0..<emptyCount {
                        rank.append(Empty())
                    }
                } else {
                    rank.append(Util.shared.charToPiece(char: f))
                }
            }
            board.append(rank)
        }
        
        castling.white.kingSide = match.output.10.contains("K")
        castling.white.queenSide = match.output.10.contains("Q")
        castling.black.kingSide = match.output.10.contains("k")
        castling.black.queenSide = match.output.10.contains("q")
        
        enpassant = Util.shared.convertFileStringToInt(file: String(match.output.11.prefix(1)))
        if let temp = match.output.12 {
            moveCount50 = Int(temp)!
        }
        if let temp = match.output.13 {
            turn = (String(match.output.9) == "w" ? Int(temp)!*2-2 : Int(temp)!*2-1)
        } else {
            turn = (String(match.output.9) == "w" ? 0 : 1)
        }
        
        legalMoves = getLegalMoves()
    }
    
    func getTurn() -> String {
        return turn%2 == 0 ? "\(turn/2+1)." : "\(turn/2+1)..."
    }
    
    func convertPGNtoCoordinate(pgn: String) -> (move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int)), promotion: Piece.Type?)? {
//        e4 Re4 Rxe4 Rhe4 0-0-0 e8=Q
        if pgn == "0-0" || pgn == "O-O" {
            if turn%2 == Color.white.rawValue {
                return (move: (from: (rank: 7, file: 4), to: (rank: 7, file: 6)), promotion: nil)
            } else {
                return (move: (from: (rank: 0, file: 4), to: (rank: 0, file: 6)), promotion: nil)
            }
        }
        if pgn == "0-0-0" || pgn == "O-O-O" {
            if turn%2 == Color.white.rawValue {
                return (move: (from: (rank: 7, file: 4), to: (rank: 7, file: 2)), promotion: nil)
            } else {
                return (move: (from: (rank: 0, file: 4), to: (rank: 0, file: 2)), promotion: nil)
            }
        }
        
        let pgnRegex = /^([KQRBN])?([a-h])?(x)?([a-h])([1-8])(=)?([QRBN])?([+#])?$/
        
        guard let match = pgn.wholeMatch(of: pgnRegex) else {
            return nil
        }
        let (matchPGN, matchPiece, matchPieceFile, matchTake, matchFile, matchRank, matchPromotion, matchPromotionPiece, matchCheck) = match.output
        let piece: Piece.Type
        if let matchPiece = matchPiece {
            piece = type(of: Util.shared.charToPiece(char: matchPiece.first!))
        } else {
            piece = Pawn.self
        }
        let promotionPiece: Piece.Type?
        if let _ = matchPromotion, let matchPromotionPiece = matchPromotionPiece {
            promotionPiece = type(of: Util.shared.charToPiece(char: matchPromotionPiece.first!))
        } else {
            promotionPiece = nil
        }
        
        guard let matchRank = Int(String(matchRank)) else {
            return nil
        }
        guard let matchFile = Util.shared.convertFileStringToInt(file: String(matchFile)) else {
            return nil
        }
        let to: (rank: Int, file: Int) = (rank: 8-matchRank, file: matchFile)
        for legalMove in legalMoves {
            if legalMove.to == to
                && type(of: board[legalMove.from.rank][legalMove.from.file]) == piece {
                guard let matchPieceFile = Util.shared.convertFileStringToInt(file: String(matchPieceFile ?? "")) else {
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

