//
//  EvalChart.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.10.18.
//

import UIKit

class EvalChartView: UIView {
    private var eval: Float?
    
    private let whiteColor: UIColor = .white
    private let blackColor: UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawChart(eval: 0.0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawChart(eval: 0.0)
    }
    
    private func sigmoid(num: Float) -> Float {
        return 1 / (1 + exp(-0.5*num))
    }
    
    func drawChart(eval: Float?) {
        self.eval = eval
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        guard let eval = eval else { return }
        
        let sigmoidEval = sigmoid(num: eval)
        
        let whiteRect = CGRect(x: 0, y: height*CGFloat(1-sigmoidEval), width: width, height: height*CGFloat(sigmoidEval))
        let whitePath = UIBezierPath(rect: whiteRect)
        whiteColor.setFill()
        whitePath.fill()
        
        let blackRect = CGRect(x: 0, y: 0, width: width, height: height*CGFloat(1-sigmoidEval))
        let blackPath = UIBezierPath(rect: blackRect)
        blackColor.setFill()
        blackPath.fill()
        
        if eval >= 0 {
            let whiteParagraphStyle = NSMutableParagraphStyle()
            whiteParagraphStyle.alignment = .center
            let whiteAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8, weight: .bold),
                .paragraphStyle: whiteParagraphStyle,
                .foregroundColor: blackColor
            ]
            let whiteTextSize = String(eval).size(withAttributes: whiteAttributes)
            let whiteTextRect = CGRect(x: 0, y: height - whiteTextSize.height - 8, width: whiteRect.width, height: whiteTextSize.height)
            String(eval).draw(in: whiteTextRect, withAttributes: whiteAttributes)
        } else {
            let blackParagraphStyle = NSMutableParagraphStyle()
            blackParagraphStyle.alignment = .center
            let blackAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8, weight: .bold),
                .paragraphStyle: blackParagraphStyle,
                .foregroundColor: whiteColor
            ]
            let blackTextSize = String(eval).size(withAttributes: blackAttributes)
            let blackTextRect = CGRect(x: 0, y: 8, width: blackRect.width, height: blackTextSize.height)
            String(-eval).draw(in: blackTextRect, withAttributes: blackAttributes)
        }
    }
}
