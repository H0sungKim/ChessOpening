//
//  Rook.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Rook: Piece {
    let color: Engine.Color
    
    required init(color: Engine.Color) {
        self.color = color
    }
    
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)] {
        var moves: [(rank: Int, file: Int)] = []
        let allDirections: [(rank: Int, file: Int)] = [
            (0, 1), (1, 0), (0, -1), (-1, 0)
        ]
        for direction in allDirections {
            var step = 1
            while true {
                let moveCoordinate = (rank: rank+direction.rank*step, file: file+direction.file*step)
                if !(Util.shared.isValidCoordinate(coordinate: moveCoordinate)) {
                    break
                }
                if board[moveCoordinate.rank][moveCoordinate.file] is Empty {
                    moves.append(moveCoordinate)
                } else {
                    if self.color != board[moveCoordinate.rank][moveCoordinate.file].color {
                        moves.append(moveCoordinate)
                    }
                    break
                }
                step += 1
            }
        }
        return moves
    }
    
    static func getString(color: Engine.Color) -> String {
        return color == .white ? "R" : "r"
    }
    func getString() -> String {
        return Rook.getString(color: self.color)
    }
}
