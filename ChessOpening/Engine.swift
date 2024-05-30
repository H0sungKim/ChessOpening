//
//  Engine.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import Foundation

class Engine {
    private static let EMPTY: Int = 0
    private static let WHITE: Int = 1
    private static let BLACK: Int = 2
    
    private static var turn: Int = 0
    
    private static var board: [[Piece]] = [
        [Rook(color: BLACK), Knight(color: BLACK), Bishop(color: BLACK), Queen(color: BLACK), King(color: BLACK), Bishop(color: BLACK), Knight(color: BLACK), Rook(color: BLACK)],
        [Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK), Pawn(color: BLACK)],
        [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
        [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
        [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
        [Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty(), Empty()],
        [Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE), Pawn(color: WHITE)],
        [Rook(color: WHITE), Knight(color: WHITE), Bishop(color: WHITE), Queen(color: WHITE), King(color: WHITE), Bishop(color: WHITE), Knight(color: WHITE), Rook(color: WHITE)],
    ]
    
    private class func isValidCoordinate(x: Int, y: Int) -> Bool {
        if x < 0 || x > 7 || y < 0 || y > 7 {
            return false
        }
        return true
    }
    private class func isValidCoordinate(coordinate: (Int, Int)) -> Bool {
        let x = coordinate.0
        let y = coordinate.1
        if x < 0 || x > 7 || y < 0 || y > 7 {
            return false
        }
        return true
    }
    
    private class func getColor(coordinate: (Int, Int)) -> Int {
        return board[coordinate.0][coordinate.1].color
    }
    private class func getColor(x: Int, y: Int) -> Int {
        return board[x][y].color
    }
    
    protocol Piece {
        var color: Int { get }
        func getMove(x: Int, y: Int) -> [(Int, Int)]
    }

    class Empty: Piece {
        var color: Int
        
        init() {
            self.color = Engine.EMPTY
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            return []
        }
    }
    class King: Piece {
        let color: Int
        
        init(color: Int) {
            self.color = color
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            var moves: [(Int, Int)] = []
            
            
            
            
            
            return moves
        }
    }
    
    class Queen: Piece {
        let color: Int
        
        init(color: Int) {
            self.color = color
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            <#code#>
        }
        
        
    }
    class Rook: Piece {
        let color: Int
        
        init(color: Int) {
            self.color = color
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            <#code#>
        }
        
        
    }
    class Bishop: Piece {
        let color: Int
        
        init(color: Int) {
            self.color = color
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            var moves: [(Int, Int)] = []
            let allDirections: [(Int, Int)] = [
                (1, 1), (1, -1), (-1, -1), (-1, 1)
            ]
            for direction in allDirections {
                var step = 1
                while true {
                    let moveCoordinate = (x+direction.0*step, y+direction.1*step)
                    if !(Engine.isValidCoordinate(coordinate: moveCoordinate)) {
                        break
                    }
                    if Engine.getColor(coordinate: moveCoordinate) == Engine.EMPTY {
                        moves.append(moveCoordinate)
                    } else {
                        if Engine.getColor(coordinate: moveCoordinate) != Engine.getColor(x: x, y: y) {
                            moves.append(moveCoordinate)
                        }
                        break
                    }
                    step += 1
                }
            }
        }
    }
    class Knight: Piece {
        let color: Int
        
        init(color: Int) {
            self.color = color
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            var moves: [(Int, Int)] = []
            let allMoves: [(Int, Int)] = [
                (1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)
            ]
            for move in allMoves {
                let moveCoordinate = (x+move.0, y+move.1)
                if Engine.isValidCoordinate(coordinate: moveCoordinate) {
                    if self.color != Engine.getColor(coordinate: moveCoordinate) {
                        moves.append(moveCoordinate)
                    }
                }
            }
            return moves
        }
    }
    class Pawn: Piece {
        let color: Int
        
        init(color: Int) {
            self.color = color
        }
        
        func getMove(x: Int, y: Int) -> [(Int, Int)] {
            <#code#>
        }
        
        
    }

    class Cell {
        private var piece: Piece?
        
        
    }
}
