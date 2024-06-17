//
//  Empty.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Empty: Piece {
    let engine: Engine
    let color: Int = -1
    
    init(engine: Engine) {
        self.engine = engine
    }
    
    func getMove(x: Int, y: Int) -> [(Int, Int)] {
        return []
    }
}
