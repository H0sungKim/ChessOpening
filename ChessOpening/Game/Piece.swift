//
//  Piece.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.31.
//

import Foundation

protocol Piece {
    var engine: Engine { get }
    var color: Int { get }
    
    func getMove(x: Int, y: Int) -> [(Int, Int)]
}