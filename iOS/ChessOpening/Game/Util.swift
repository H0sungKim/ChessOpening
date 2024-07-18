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
}
