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
    private let imgBQueen: UIImage = UIImage(named: "bqueen")!
    private let imgBRook: UIImage = UIImage(named: "brook")!
    private let imgBBishop: UIImage = UIImage(named: "bbishop")!
    private let imgBKnight: UIImage = UIImage(named: "bknight")!
    private let imgBPawn: UIImage = UIImage(named: "bpawn")!
    
    private let imgWKing: UIImage = UIImage(named: "wking")!
    private let imgWQueen: UIImage = UIImage(named: "wqueen")!
    private let imgWRook: UIImage = UIImage(named: "wrook")!
    private let imgWBishop: UIImage = UIImage(named: "wbishop")!
    private let imgWKnight: UIImage = UIImage(named: "wknight")!
    private let imgWPawn: UIImage = UIImage(named: "wpawn")!
    
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
                let path = UIBezierPath(rect: CGRect(x: CGFloat(j)*cellSize, y: CGFloat(i)*cellSize, width: cellSize, height: cellSize))
                if (i+j)%2 == 0 {
                    lightBrown.setFill()
                } else {
                    darkBrown.setFill()
                }
                path.fill()
                drawPiece(piece: engine.board[i][j], x: j, y: i)
            }
        }
        
    }
    
    private func drawBackGround() {
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
    }
    
    private func drawPiece(piece: Piece, x: Int, y: Int) {
        switch piece {
        case is King :
            if piece.color == engine.BLACK {
                imgBKing.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWKing.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            }
        case is Queen :
            if piece.color == engine.BLACK {
                imgBQueen.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWQueen.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            }
        case is Rook :
            if piece.color == engine.BLACK {
                imgBRook.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWRook.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            }
        case is Bishop :
            if piece.color == engine.BLACK {
                imgBBishop.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWBishop.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            }
        case is Knight :
            if piece.color == engine.BLACK {
                imgBKnight.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWKnight.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            }
        case is Pawn :
            if piece.color == engine.BLACK {
                imgBPawn.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWPawn.draw(in: CGRect(x: CGFloat(x)*cellSize, y: CGFloat(y)*cellSize, width: cellSize, height: cellSize))
            }
        default:
            break
        }
    }
}
