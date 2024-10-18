//
//  EvalChart.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.10.18.
//

import UIKit

class EvalChartView: UIView {
    
    private var eval: Float = 0.0
    
    private let whiteColor: UIColor = .white
    private let blackColor: UIColor = .black
    
    private let blackView: UIView = UIView()
    private let lbWhite: UILabel = UILabel()
    private let lbBlack: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawChart(eval: eval)
    }
    
    func initialize() {
        self.addSubview(blackView)
        self.addSubview(lbWhite)
        self.addSubview(lbBlack)
        
        blackView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*0.5)
        blackView.backgroundColor = blackColor
        
        backgroundColor = whiteColor
        
        lbWhite.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        lbWhite.textColor = blackColor
        lbWhite.textAlignment = .center
        
        lbBlack.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        lbBlack.textColor = whiteColor
        lbBlack.textAlignment = .center
        
        drawChart(eval: eval)
    }
    
    private func sigmoid(num: Float) -> Float {
        return 1 / (1 + exp(-0.5*num))
    }
    
    func drawChart(eval newEval: Float?) {
        
        if let newEval {
            eval = newEval
        }
        
        let width = self.frame.width
        let height = self.frame.height
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.blackView.frame = CGRect(x: 0, y: 0, width: width, height: height*CGFloat(1-self.sigmoid(num: newEval ?? self.eval)))
        }
        
        let textSize = String(abs(eval)).size(withAttributes: [
            .font: UIFont.systemFont(ofSize: 8, weight: .bold)
        ])
        
        if eval >= 0 {
            lbWhite.isHidden = false
            lbBlack.isHidden = true
            lbWhite.frame = CGRect(x: 0, y: height - textSize.height - 8, width: width, height: textSize.height)
            lbWhite.text = "\(abs(eval))"
        } else {
            lbBlack.isHidden = false
            lbWhite.isHidden = true
            lbBlack.frame = CGRect(x: 0, y: 8, width: width, height: textSize.height)
            lbBlack.text = "\(abs(eval))"
        }
    }
}
