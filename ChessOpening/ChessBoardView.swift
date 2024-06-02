//
//  ChessBoardView.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import UIKit
import AVFoundation

class ChessBoardView: UIView {
    
    private let engine: Engine = Engine()
    
    private let lightBrown: UIColor = UIColor(red: 240/255, green: 217/255, blue: 181/255, alpha: 1)
    private let darkBrown: UIColor = UIColor(red: 181/255, green: 136/255, blue: 99/255, alpha: 1)
    private var cellSize: CGFloat = 0
    
    private let imgBKing: UIImage = UIImage(named: "bking")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        drawChessBoard()
    }
    
    private func initialize() {
        cellSize = UIScreen.main.bounds.width/8
    }
    private func drawChessBoard() {
        for i in 0..<8 {
            for j in 0..<8 {
                let path = UIBezierPath(rect: CGRect(x: CGFloat(i)*cellSize, y: CGFloat(j)*cellSize, width: cellSize, height: cellSize))
                if (i+j)%2 == 0 {
                    lightBrown.setFill()
                } else {
                    darkBrown.setFill()
                }
                path.fill()
                
                
                
            }
        }
        drawPiece(piece: King(engine: engine, color: engine.BLACK), x: 2, y: 3)
    }
    
    private func drawPiece(piece: Piece, x: Int, y: Int) {
        switch piece {
        case is King :
            if piece.color == engine.BLACK {
                imgBKing.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.BLACK {
                
            }
        default:
            break
        }
    }
}
