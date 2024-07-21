//
//  Empty.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Empty: Piece {
    let color: Engine.Color = .empty
    
    required init(color: Engine.Color = .empty) {
    }
    
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)] {
        return []
    }
    
    static func getString(color: Engine.Color) -> String {
        return ""
    }
    func getString() -> String {
        return Empty.getString(color: self.color)
    }
}
