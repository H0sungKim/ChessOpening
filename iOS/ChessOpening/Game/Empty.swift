//
//  Empty.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Empty: Piece {
    let color: Int = -1
    
    required init(color: Int = Engine.EMPTY) {
    }
    
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)] {
        return []
    }
    
    static func getString(color: Int) -> String {
        return ""
    }
    func getString() -> String {
        return Empty.getString(color: self.color)
    }
}
