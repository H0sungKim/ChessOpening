//
//  ChessBoardView.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//

import UIKit
import AVFoundation

class ChessBoardView: UIView {
    
//    Touch
//    Began 좌표 기억
//    Moved 피스랑 좌표 리턴
//    Ended 드래그가 됐으면 piece move 드래그 아니면 선택/해제
//
//    Draw
//    현재 보드 -> 선택된 칸에 흐릿한 레이어 덧 -> 선택된 기물
    
    
    private let engine: Engine = Engine()
    
    private var isTouched: Bool = false
    private var isDragged: Bool = false
    private var selectedCell: (Int, Int)?
    private var draggedPiece: (CGFloat, CGFloat)?
    
    private let lightBrown: UIColor = UIColor(red: 240/255, green: 217/255, blue: 181/255, alpha: 1)
    private let darkBrown: UIColor = UIColor(red: 181/255, green: 136/255, blue: 99/255, alpha: 1)
    private let selectedGreen: UIColor = UIColor(red: 24/255, green: 89/255, blue: 31/255, alpha: 0.5)
    private let selectedGray: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
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
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setNeedsDisplay()
    }
    
    func startAnimation(move: ((Int, Int), (Int, Int))) {
        let shapeLayer = CAShapeLayer()
        
        let startPoint = CGPoint(x: CGFloat(move.0.1)*cellSize + cellSize/2, y: CGFloat(move.0.0)*cellSize + cellSize/2)
        let endPoint = CGPoint(x: CGFloat(move.1.1)*cellSize + cellSize/2, y: CGFloat(move.1.0)*cellSize + cellSize/2)
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: cellSize, height: cellSize)
        
        let image = getImage(coordinate: move.0)
        shapeLayer.contents = image.cgImage
        layer.addSublayer(shapeLayer)
        
        shapeLayer.position = startPoint
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: startPoint)
        animation.toValue = NSValue(cgPoint: endPoint)
        animation.duration = TimeInterval(0.2)
        shapeLayer.add(animation, forKey: "position")
        shapeLayer.position = endPoint
    }
    
    
    override func draw(_ rect: CGRect) {
        // 현재 보드 -> 선택된 칸에 흐릿한 레이어 덧 -> 선택된 기물
        
        drawChessBoard()
        drawNowSelectedCell()
        drawNowSelectedPiece()
    }
    
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
                drawPiece(piece: getImage(coordinate: (r, c)), x: c, y: r)
            }
        }
    }
    private func drawNowSelectedCell() {
        if isTouched {
            if let selectedCell = selectedCell {
                let path = UIBezierPath(rect: CGRect(x: CGFloat(selectedCell.1)*cellSize, y: CGFloat(selectedCell.0)*cellSize, width: cellSize, height: cellSize))
                selectedGreen.setFill()
                path.fill()
            }
            // TODO점 찍기
            
        }
    }
    
    private func drawNowSelectedPiece() {
        if isDragged {
            if let selectedCell = selectedCell, let draggedPiece = draggedPiece {
                let nowDraggedCell: (CGFloat, CGFloat) = (CGFloat(Int(draggedPiece.0/cellSize)), CGFloat(Int(draggedPiece.1/cellSize)))
                let path = UIBezierPath(arcCenter: CGPoint(x: nowDraggedCell.0*cellSize + cellSize/2, y: nowDraggedCell.1*cellSize + cellSize/2), radius: cellSize, startAngle: 0, endAngle: Double.pi*2, clockwise: true)
                selectedGray.setFill()
                path.fill()
                
                drawPiece(piece: getImage(coordinate: selectedCell), x: 0, y: 0, dx: draggedPiece.0-cellSize/2, dy: draggedPiece.1-cellSize/2)
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
    
    private func getImage(coordinate: (Int, Int)) -> UIImage {
        let piece = engine.board[coordinate.0][coordinate.1]
        switch piece {
        case is King :
            if piece.color == engine.BLACK {
                return imgBKing
            } else if piece.color == engine.WHITE {
                return imgWKing
            }
        case is Queen :
            if piece.color == engine.BLACK {
                return imgBQueen
            } else if piece.color == engine.WHITE {
                return imgWQueen
            }
        case is Rook :
            if piece.color == engine.BLACK {
                return imgBRook
            } else if piece.color == engine.WHITE {
                return imgWRook
            }
        case is Bishop :
            if piece.color == engine.BLACK {
                return imgBBishop
            } else if piece.color == engine.WHITE {
                return imgWBishop
            }
        case is Knight :
            if piece.color == engine.BLACK {
                return imgBKnight
            } else if piece.color == engine.WHITE {
                return imgWKnight
            }
        case is Pawn :
            if piece.color == engine.BLACK {
                return imgBPawn
            } else if piece.color == engine.WHITE {
                return imgWPawn
            }
        default:
            break
        }
        return UIImage()
    }
    
    private func drawPiece(piece: UIImage, x: Int, y: Int, dx: CGFloat = 0, dy: CGFloat = 0) {
        piece.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize, height: cellSize))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let point = touches.first?.location(in: self) {
            let coordinate = (Int(point.y/cellSize), Int(point.x/cellSize))
            if engine.board[coordinate.0][coordinate.1] is Empty {
                selectedCell = nil
            } else {
                selectedCell = (Int(point.y/cellSize), Int(point.x/cellSize))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self), let selectedCell = selectedCell {
            
            isDragged = true
            draggedPiece = (point.x, point.y)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self), let selectedCell = selectedCell {
            let move = (selectedCell,(Int(point.y/cellSize), Int(point.x/cellSize)))
            
//            isDragged isTouched
//            t t 드래그
//            t f 드래그
//            f t 움직임 클릭
//            f f 기물 클릭
            
//            빈곳 찍은
            if isDragged {
                if engine.isLegalMove(move: move) {
                    engine.movePiece(move: move)
                }
                isTouched = false
                isDragged = false
                self.selectedCell = nil
                draggedPiece = nil
            } else {
                if isTouched {
                    
                } else {
                    
                }
            }
            
            
            isDragged = false
            setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("C")
        
        isDragged = false
        setNeedsDisplay()
    }
}
