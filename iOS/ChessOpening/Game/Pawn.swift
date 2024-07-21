//
//  Pawn.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

class Pawn: Piece {
    let color: Engine.Color
    
    required init(color: Engine.Color) {
        self.color = color
    }
    
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)] {
        var moves: [(rank: Int, file: Int)] = []
        let direction = 2*color.rawValue - 1
        if Util.shared.isValidCoordinate(coordinate: (rank+direction, file)) && board[rank+direction][file] is Empty {
            moves.append((rank+direction, file))
            if rank == 6-color.rawValue*5 && board[rank+2*direction][file] is Empty {
                moves.append((rank+2*direction, file))
            }
        }
        if Util.shared.isValidCoordinate(coordinate: (rank+direction, file-1)) && !(board[rank+direction][file-1] is Empty) && board[rank+direction][file-1].color != color {
            moves.append((rank+direction, file-1))
        }
        if Util.shared.isValidCoordinate(coordinate: (rank+direction, file+1)) && !(board[rank+direction][file+1] is Empty) && board[rank+direction][file+1].color != color {
            moves.append((rank+direction, file+1))
        }
        return moves
    }
    
    static func getString(color: Engine.Color) -> String {
        return color == .white ? "P" : "p"
    }
    func getString() -> String {
        return Pawn.getString(color: self.color)
    }
}
