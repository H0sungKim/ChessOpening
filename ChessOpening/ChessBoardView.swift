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
    private var selectedCell: (rank: Int, file: Int)?
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
    
    private func startAnimation(move: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) {
        let hideLayer: CALayer = CALayer()
        hideLayer.frame = .init(x: CGFloat(move.from.file)*cellSize, y: CGFloat(move.from.rank)*cellSize, width: cellSize, height: cellSize)
        if (move.from.rank + move.from.file) % 2 == 0 {
            hideLayer.backgroundColor = lightBrown.cgColor
        } else {
            hideLayer.backgroundColor = darkBrown.cgColor
        }
        layer.addSublayer(hideLayer)
        
        let shapeLayer = CAShapeLayer()
        
        let startPoint = CGPoint(x: CGFloat(move.from.file)*cellSize + cellSize/2, y: CGFloat(move.from.rank)*cellSize + cellSize/2)
        let endPoint = CGPoint(x: CGFloat(move.to.file)*cellSize + cellSize/2, y: CGFloat(move.to.rank)*cellSize + cellSize/2)
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: cellSize, height: cellSize)
        
        let image = getImage(coordinate: move.from)
        shapeLayer.contents = image.cgImage
        layer.addSublayer(shapeLayer)
        
        shapeLayer.position = startPoint
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: startPoint)
        animation.toValue = NSValue(cgPoint: endPoint)
        animation.duration = TimeInterval(0.2)
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            shapeLayer.removeFromSuperlayer()
            hideLayer.removeFromSuperlayer()
            self.setNeedsDisplay()
        }
        
        shapeLayer.add(animation, forKey: "position")
        shapeLayer.position = endPoint
        
        CATransaction.commit()
    }
    
    
    override func draw(_ rect: CGRect) {
        // 현재 보드 -> 선택된 칸에 흐릿한 레이어 덧 -> 선택된 기물
        
        drawChessBoard()
        drawNowSelectedCell()
        drawNowSelectedPiece()
        drawArrow(arrow: ((0, 0), (2, 3)))
    }
    
    private func drawCorner(coordinate: (rank: Int, file: Int)) {
        let cornerX = cellSize * CGFloat(coordinate.file)
        let cornerY = cellSize * CGFloat(coordinate.rank)
        
        for i in 0...1 {
            for j in 0...1 {
                let i = CGFloat(i)
                let j = CGFloat(j)
                let cornerPath = UIBezierPath()
                cornerPath.move(to: CGPoint(x: cornerX + cellSize*i, y: cornerY + cellSize*j))
                cornerPath.addLine(to: CGPoint(x: cornerX + cellSize/4 + cellSize/2*i, y: cornerY + cellSize*j))
                cornerPath.addLine(to: CGPoint(x: cornerX + cellSize*i, y: cornerY + cellSize/4 + cellSize/2*j))
                cornerPath.close()
                cornerPath.fill()
            }
        }
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
        if !isTouched {
            return
        }
        guard let selectedCell = selectedCell else {
            return
        }
        let selectedCellPath = UIBezierPath(rect: CGRect(x: CGFloat(selectedCell.file)*cellSize, y: CGFloat(selectedCell.rank)*cellSize, width: cellSize, height: cellSize))
        selectedGreen.setFill()
        selectedCellPath.fill()
        for legalMove in engine.legalMoves {
            if legalMove.from == selectedCell {
                if engine.board[legalMove.to.rank][legalMove.to.file] is Empty {
                    let circlePath = UIBezierPath(arcCenter: CGPoint(x: cellSize*CGFloat(legalMove.to.file) + cellSize/2, y: cellSize*CGFloat(legalMove.to.rank) + cellSize/2), radius: cellSize/6, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                    circlePath.fill()
                } else {
                    drawCorner(coordinate: legalMove.to)
                }
            }
        }
        if !isDragged {
            drawPiece(piece: getImage(coordinate: selectedCell), x: selectedCell.file, y: selectedCell.rank)
        }
    }
    
    private func drawNowSelectedPiece() {
        if !isDragged {
            return
        }
        guard let selectedCell = selectedCell, let draggedPiece = draggedPiece else {
            return
        }
        let nowDraggedCell: (CGFloat, CGFloat) = (CGFloat(Int(draggedPiece.0/cellSize)), CGFloat(Int(draggedPiece.1/cellSize)))
        let path = UIBezierPath(arcCenter: CGPoint(x: nowDraggedCell.0*cellSize + cellSize/2, y: nowDraggedCell.1*cellSize + cellSize/2), radius: cellSize, startAngle: 0, endAngle: Double.pi*2, clockwise: true)
        selectedGray.setFill()
        path.fill()
        
        drawPiece(piece: getImage(coordinate: selectedCell), x: 0, y: 0, dx: draggedPiece.0-cellSize, dy: draggedPiece.1-cellSize, rate: 2)
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
    
    private func drawArrow(arrow: (from: (rank: Int, file: Int), to: (rank: Int, file: Int))) {
        let dx: CGFloat = CGFloat((arrow.to.file - arrow.from.file)) * cellSize
        let dy: CGFloat = CGFloat((arrow.to.rank - arrow.from.rank)) * cellSize
        let r: CGFloat = sqrt(dx * dx + dy * dy)
        
        let sin: CGFloat = dy / r
        let cos: CGFloat = dx / r
        
        let pointHead: (x: CGFloat, y: CGFloat) = (CGFloat(arrow.to.file) * cellSize + cellSize/2, CGFloat(arrow.to.rank) * cellSize + cellSize/2)
        let shaftHead: (x: CGFloat, y: CGFloat) = (CGFloat(arrow.from.file) * cellSize + cellSize/2, CGFloat(arrow.from.rank) * cellSize + cellSize/2)
        let leftPoint: (x: CGFloat, y: CGFloat) = (pointHead.x - cellSize * (sqrt(3)*cos+sin) / 4, pointHead.y + cellSize * (cos-sqrt(3)*sin) / 4)
        let rightPoint: (x: CGFloat, y: CGFloat) = (pointHead.x + cellSize * (sin-sqrt(3)*cos) / 4, pointHead.y - cellSize * (sqrt(3)*sin+cos) / 4)
        let middlePoint: (x: CGFloat, y: CGFloat) = ((leftPoint.x+rightPoint.x)/2, (leftPoint.y+rightPoint.y)/2)
        
        let pointPath = UIBezierPath()
        pointPath.move(to: CGPoint(x: pointHead.x, y: pointHead.y))
        pointPath.addLine(to: CGPoint(x: leftPoint.x, y: leftPoint.y))
        pointPath.addLine(to: CGPoint(x: rightPoint.x, y: rightPoint.y))
        pointPath.close()
        selectedGreen.setFill()
        pointPath.fill()
        
        let shaftPath = UIBezierPath()
        shaftPath.move(to: CGPoint(x: shaftHead.x, y: shaftHead.y))
        shaftPath.addLine(to: CGPoint(x: middlePoint.x, y: middlePoint.y))
        shaftPath.lineWidth = 8
        selectedGreen.setStroke()
        shaftPath.stroke()
    }
    
    private func getImage(coordinate: (Int, Int)) -> UIImage {
        let piece = engine.board[coordinate.0][coordinate.1]
        switch piece {
        case is King :
            if piece.color == Engine.BLACK {
                return imgBKing
            } else if piece.color == Engine.WHITE {
                return imgWKing
            }
        case is Queen :
            if piece.color == Engine.BLACK {
                return imgBQueen
            } else if piece.color == Engine.WHITE {
                return imgWQueen
            }
        case is Rook :
            if piece.color == Engine.BLACK {
                return imgBRook
            } else if piece.color == Engine.WHITE {
                return imgWRook
            }
        case is Bishop :
            if piece.color == Engine.BLACK {
                return imgBBishop
            } else if piece.color == Engine.WHITE {
                return imgWBishop
            }
        case is Knight :
            if piece.color == Engine.BLACK {
                return imgBKnight
            } else if piece.color == Engine.WHITE {
                return imgWKnight
            }
        case is Pawn :
            if piece.color == Engine.BLACK {
                return imgBPawn
            } else if piece.color == Engine.WHITE {
                return imgWPawn
            }
        default:
            break
        }
        return UIImage()
    }
    
    private func drawPiece(piece: UIImage, x: Int, y: Int, dx: CGFloat = 0, dy: CGFloat = 0, rate: CGFloat = 1) {
        piece.draw(in: CGRect(x: CGFloat(x)*cellSize+dx, y: CGFloat(y)*cellSize+dy, width: cellSize*rate, height: cellSize*rate))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        let coordinate = (rank: Int(point.y/cellSize), file: Int(point.x/cellSize))
        if isTouched, let selectedCell = selectedCell {
            let move = (from: selectedCell, to: coordinate)
            self.selectedCell = nil
            isTouched = false
            if engine.isLegalMove(move: move) {
                startAnimation(move: move)
                engine.movePiece(move: move)
            } else {
                setNeedsDisplay()
            }
        } else {
            if engine.board[coordinate.rank][coordinate.file] is Empty || engine.board[coordinate.rank][coordinate.file].color != engine.turn%2 {
                selectedCell = nil
                isTouched = false
            } else {
                selectedCell = (Int(point.y/cellSize), Int(point.x/cellSize))
                isTouched = true
            }
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        if !isTouched {
            return
        }
        isDragged = true
        draggedPiece = (point.x, point.y)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragged {
            return
        }
        guard let point = touches.first?.location(in: self), let selectedCell = selectedCell else {
            return
        }
        let move = (selectedCell,(Int(point.y/cellSize), Int(point.x/cellSize)))
        if engine.isLegalMove(move: move) {
            engine.movePiece(move: move)
        }
        isTouched = false
        self.selectedCell = nil
        draggedPiece = nil
        isDragged = false
        setNeedsDisplay()
    
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragged = false
        setNeedsDisplay()
    }
}
