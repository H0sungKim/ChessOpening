//
//  King.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation
import UIKit

class King: Piece {
    let engine: Engine
    let color: Int
    
    init(engine: Engine, color: Int) {
        self.engine = engine
        self.color = color
    }
    
    func getMove(row: Int, column: Int) -> [(row: Int, column: Int)] {
        var moves: [(row: Int, column: Int)] = []
        let allMoves: [(row: Int, column: Int)] = [
            (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)
        ]
        for move in allMoves {
            let moveCoordinate = (row: row+move.row, column: column+move.column)
            if engine.isValidCoordinate(coordinate: moveCoordinate) {
                if self.color != engine.getColor(coordinate: moveCoordinate) {
                    moves.append(moveCoordinate)
                }
            }
        }
        return moves
    }
}
