//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    let EMPTY: Int = 0
    let WHITE: Int = 1
    let BLACK: Int = 2
    
    var turn: Int = 0
    
    // (White King Side, White Queen Side, Black King Side, Black Queen Side)
    var castling: (Bool, Bool, Bool, Bool) = (true, true, true, true)
    
    private var board: [[Piece]] = []
    
    init() {
        board = [
            [Rook(engine: self, color: BLACK), Knight(engine: self, color: BLACK)],
            
        ]
    }
    
    func isValidCoordinate(x: Int, y: Int) -> Bool {
        if x < 0 || x > 7 || y < 0 || y > 7 {
            return false
        }
        return true
    }
    func isValidCoordinate(coordinate: (Int, Int)) -> Bool {
        let x = coordinate.0
        let y = coordinate.1
        if x < 0 || x > 7 || y < 0 || y > 7 {
            return false
        }
        return true
    }
    
    func getColor(coordinate: (Int, Int)) -> Int {
        return board[coordinate.0][coordinate.1].color
    }
    func getColor(x: Int, y: Int) -> Int {
        return board[x][y].color
    }
}
