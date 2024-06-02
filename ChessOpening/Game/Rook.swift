//
//  Rook.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Rook: Piece {
    let engine: Engine
    let color: Int
    
    init(engine: Engine, color: Int) {
        self.engine = engine
        self.color = color
    }
    
    func getMove(x: Int, y: Int) -> [(Int, Int)] {
        var moves: [(Int, Int)] = []
        let allDirections: [(Int, Int)] = [
            (0, 1), (1, 0), (0, -1), (-1, 0)
        ]
        for direction in allDirections {
            var step = 1
            while true {
                let moveCoordinate = (x+direction.0*step, y+direction.1*step)
                if !(engine.isValidCoordinate(coordinate: moveCoordinate)) {
                    break
                }
                if engine.getColor(coordinate: moveCoordinate) == engine.EMPTY {
                    moves.append(moveCoordinate)
                } else {
                    if engine.getColor(coordinate: moveCoordinate) != engine.getColor(x: x, y: y) {
                        moves.append(moveCoordinate)
                    }
                    break
                }
                step += 1
            }
        }
        return moves
    }
}
