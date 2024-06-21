//
//  Pawn.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Pawn: Piece {
    let color: Int
    
    required init(color: Int) {
        self.color = color
    }
    
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)] {
        return []
    }
    
    
}
