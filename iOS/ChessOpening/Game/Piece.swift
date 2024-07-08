//
//  Piece.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

protocol Piece {
    var color: Int { get }
    
    init(color: Int)
    func getMove(board: [[Piece]], rank: Int, file: Int) -> [(rank: Int, file: Int)]
    static func getString(color: Int) -> String
    func getString() -> String
}
