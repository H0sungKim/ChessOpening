//
//  ChessBoardView.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import UIKit
import AVFoundation

class ChessBoardView: UIView {
    
    // 애니메이션 때만 잠시 이미지뷰 생성하고 끝나면 지우기 ?
    
    private let engine: Engine = Engine()
    
    private var gameTimer: Timer?
    
    private var nowSelected: (Int, Int)?
    private var difNowSelected: (CGFloat, CGFloat)?
    private var destinationNowSelecter: (Int, Int)?
    private let shapeLayer = CAShapeLayer()
    
    private let lightBrown: UIColor = UIColor(red: 240/255, green: 217/255, blue: 181/255, alpha: 1)
    private let darkBrown: UIColor = UIColor(red: 181/255, green: 136/255, blue: 99/255, alpha: 1)
//    private let selectedGreen: UIColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    private let cellSize: CGFloat = UIScreen.main.bounds.width/8
    
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
        startAnimation(image: imgWKing, from: (1,1), to: (2,3), duration: TimeInterval(0.5))
    }
    
    override func draw(_ rect: CGRect) {
        // 현재 보드 -> 선택된 칸에 흐릿한 레이어 덧 -> 선택된 기물
        drawChessBoard()
    }
    
    private func initialize() {
//        cellSize = UIScreen.main.bounds.width/8
        
    }
    
//    private func startAnimation() {
//        
//    }
    
    private func drawChessBoard() {
        for r in 0..<8 {
            for c in 0..<8 {
                let path = UIBezierPath(rect: CGRect(x: CGFloat(c)*cellSize, y: CGFloat(r)*cellSize, width: cellSize, height: cellSize))
                if (r+c)%2 == 0 {
                    lightBrown.setFill()
                } else {
                    darkBrown.setFill()
                }
                path.fill()
                drawPiece(piece: engine.board[r][c], x: c, y: r)
            }
        }
    }
    func startAnimation(image: UIImage, from: (Int, Int), to: (Int, Int), duration: TimeInterval) {
        let startPoint = CGPoint(x: CGFloat(from.1)*cellSize + cellSize/2, y: CGFloat(from.0)*cellSize + cellSize/2)
        let endPoint = CGPoint(x: CGFloat(to.1)*cellSize + cellSize/2, y: CGFloat(to.0)*cellSize + cellSize/2)
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: cellSize, height: cellSize)
        
        
        // 3. CAShapeLayer에 UIImage 추가
        shapeLayer.contents = imgBKing.cgImage
        layer.addSublayer(shapeLayer)
        
        shapeLayer.position = startPoint
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: startPoint)
        animation.toValue = NSValue(cgPoint: endPoint)
        animation.duration = duration
        shapeLayer.add(animation, forKey: "position")
        shapeLayer.position = endPoint
    }
    private func drawNowSelectedCell() {
        if let nowSelected = nowSelected, let difNowSelected = difNowSelected {
            let path = UIBezierPath(rect: CGRect(x: CGFloat(nowSelected.1)*cellSize, y: CGFloat(nowSelected.0)*cellSize, width: cellSize, height: cellSize))
//            selectedGreen.setFill()
            path.fill()
            // 점 찍기
            drawPiece(piece: engine.board[nowSelected.0][nowSelected.1], x: nowSelected.1, y: nowSelected.0, dx: difNowSelected.0, dy: difNowSelected.1)
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
    
    private func drawPiece(piece: Piece, x: Int, y: Int, dx: CGFloat = 0, dy: CGFloat = 0) {
        switch piece {
        case is King :
            if piece.color == engine.BLACK {
                imgBKing.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWKing.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            }
        case is Queen :
            if piece.color == engine.BLACK {
                imgBQueen.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWQueen.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            }
        case is Rook :
            if piece.color == engine.BLACK {
                imgBRook.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWRook.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            }
        case is Bishop :
            if piece.color == engine.BLACK {
                imgBBishop.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWBishop.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            }
        case is Knight :
            if piece.color == engine.BLACK {
                imgBKnight.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWKnight.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            }
        case is Pawn :
            if piece.color == engine.BLACK {
                imgBPawn.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            } else if piece.color == engine.WHITE {
                imgWPawn.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
            }
        default:
            break
        }
    }
}
