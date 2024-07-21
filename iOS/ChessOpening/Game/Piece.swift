//
//  Piece.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

protocol Piece {
    var color: Engine.Color { get }
    
    init(color: Engine.Color)
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)]
    static func getString(color: Engine.Color) -> String
    func getString() -> String
}
