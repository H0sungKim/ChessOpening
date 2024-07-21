//
//  Util.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.09.
//

class Util {
    static let shared: Util = Util()
    
    private init() {
        
    }
    
    func isValidCoordinate(coordinate: (rank: Int, file: Int)) -> Bool {
        if coordinate.rank < 0 || coordinate.rank > 7 || coordinate.file < 0 || coordinate.file > 7 {
            return false
        }
        return true
    }
    
    func convertFileStringToInt(file: String) -> Int? {
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
    
    func convertFileIntToString(file: Int) -> String {
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
    
    func charToPiece(char: Character) -> Piece {
        switch char {
        case "K" :
            return King(color: .white)
        case "k" :
            return King(color: .black)
        case "Q" :
            return Queen(color: .white)
        case "q" :
            return Queen(color: .black)
        case "R" :
            return Rook(color: .white)
        case "r" :
            return Rook(color: .black)
        case "B" :
            return Bishop(color: .white)
        case "b" :
            return Bishop(color: .black)
        case "N" :
            return Knight(color: .white)
        case "n" :
            return Knight(color: .black)
        case "P" :
            return Pawn(color: .white)
        case "p" :
            return Pawn(color: .black)
        default :
            return Empty()
        }
    }
}
