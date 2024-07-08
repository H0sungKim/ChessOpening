//
//  Knight.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Knight: Piece {
    let color: Int
    
    required init(color: Int) {
        self.color = color
    }
    
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)] {
        var moves: [(rank: Int, file: Int)] = []
        let allMoves: [(rank: Int, file: Int)] = [
            (1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)
        ]
        for move in allMoves {
            let moveCoordinate = (rank: rank+move.rank, file: file+move.file)
            if isValidCoordinate(coordinate: moveCoordinate) && color != board[moveCoordinate.rank][moveCoordinate.file].color {
                moves.append(moveCoordinate)
            }
        }
        return moves
    }
    
    static func getString(color: Int) -> String {
        return color == Engine.WHITE ? "N" : "n"
    }
    func getString() -> String {
        return Knight.getString(color: self.color)
    }
}
