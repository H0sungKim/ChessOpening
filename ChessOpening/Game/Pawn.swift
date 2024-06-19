//
//  Pawn.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Pawn: Piece {
    let engine: Engine
    let color: Int
    
    init(engine: Engine, color: Int) {
        self.engine = engine
        self.color = color
    }
    
    func getMove(row: Int, column: Int) -> [(row: Int, column: Int)] {
        return []
    }
    
    
}
