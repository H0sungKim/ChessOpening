//
//  Bishop.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Bishop: Piece {
    let engine: Engine
    let color: Int
    
    init(engine: Engine, color: Int) {
        self.engine = engine
        self.color = color
    }
    
    func getMove(row: Int, column: Int) -> [(row: Int, column: Int)] {
        var moves: [(row: Int, column: Int)] = []
        let allDirections: [(row: Int, column: Int)] = [
            (1, 1), (1, -1), (-1, -1), (-1, 1)
        ]
        for direction in allDirections {
            var step = 1
            while true {
                let moveCoordinate = (row: row+direction.row*step, column: column+direction.column*step)
                if !(engine.isValidCoordinate(coordinate: moveCoordinate)) {
                    break
                }
                if engine.board[moveCoordinate.row][moveCoordinate.column] is Empty {
                    moves.append(moveCoordinate)
                } else {
                    if self.color != engine.getColor(coordinate: moveCoordinate) {
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
