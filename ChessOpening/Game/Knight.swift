//
//  Knight.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Knight: Piece {
    let engine: Engine
    let color: Int
    
    init(engine: Engine, color: Int) {
        self.engine = engine
        self.color = color
    }
    
    func getMove(x: Int, y: Int) -> [(Int, Int)] {
        var moves: [(Int, Int)] = []
        let allMoves: [(Int, Int)] = [
            (1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)
        ]
        for move in allMoves {
            let moveCoordinate = (x+move.0, y+move.1)
            if engine.isValidCoordinate(coordinate: moveCoordinate) {
                if self.color != engine.getColor(coordinate: moveCoordinate) {
                    moves.append(moveCoordinate)
                }
            }
        }
        return moves
    }
}
