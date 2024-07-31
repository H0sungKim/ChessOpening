//
//  WinRateChartView.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.31.
//

import Foundation
import UIKit

class WinRateChartView: UIView {
    private var rate: (white: Int, draws: Int, black: Int)?
    
    private let whiteColor: UIColor = .white
    private let drawsColor: UIColor = .separator
    private let blackColor: UIColor = .black
    private let backGroundColor: UIColor = .systemBackground
    private let labelColor: UIColor = .label
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
    
    
    func drawChart(rate: (white: Int, draws: Int, black: Int)?) {
        self.rate = rate
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        if let rate = rate {
            let sum: CGFloat = CGFloat(rate.white + rate.draws + rate.black)
            
            let whiteRect = CGRect(x: 0, y: 0, width: CGFloat(rate.white)/sum*width, height: height)
            let whitePath = UIBezierPath(rect: whiteRect)
            whiteColor.setFill()
            whitePath.fill()
            let whiteParagraphStyle = NSMutableParagraphStyle()
            whiteParagraphStyle.alignment = .center
            let whiteAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: whiteParagraphStyle,
                .foregroundColor: blackColor
            ]
            let whiteTextSize = String(rate.white).size(withAttributes: whiteAttributes)
            if whiteTextSize.width < whiteRect.width {
                let whiteTextRect = CGRect(x: 0, y: (height - whiteTextSize.height) / 2, width: whiteRect.width, height: whiteTextSize.height)
                String(rate.white).draw(in: whiteTextRect, withAttributes: whiteAttributes)
            }
            
            let drawsRect = CGRect(x: whiteRect.width, y: 0, width: CGFloat(rate.draws)/sum*width, height: height)
            let drawsPath = UIBezierPath(rect: drawsRect)
            drawsColor.setFill()
            drawsPath.fill()
            let drawsParagraphStyle = NSMutableParagraphStyle()
            drawsParagraphStyle.alignment = .center
            let drawsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: drawsParagraphStyle,
                .foregroundColor: whiteColor
            ]
            let drawsTextSize = String(rate.draws).size(withAttributes: drawsAttributes)
            if drawsTextSize.width < drawsRect.width {
                let drawsTextRect = CGRect(x: whiteRect.width, y: (height - drawsTextSize.height) / 2, width: drawsRect.width, height: drawsTextSize.height)
                String(rate.draws).draw(in: drawsTextRect, withAttributes: drawsAttributes)
            }
            
            let blackRect = CGRect(x: whiteRect.width+drawsRect.width, y: 0, width: CGFloat(rate.black)/sum*width, height: height)
            let blackPath = UIBezierPath(rect: blackRect)
            blackColor.setFill()
            blackPath.fill()
            let blackParagraphStyle = NSMutableParagraphStyle()
            blackParagraphStyle.alignment = .center
            let blackAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: blackParagraphStyle,
                .foregroundColor: whiteColor
            ]
            let blackTextSize = String(rate.black).size(withAttributes: blackAttributes)
            if blackTextSize.width < blackRect.width {
                let blackTextRect = CGRect(x: whiteRect.width+drawsRect.width, y: (height - blackTextSize.height) / 2, width: blackRect.width, height: blackTextSize.height)
                String(rate.black).draw(in: blackTextRect, withAttributes: blackAttributes)
            }
        } else {
            let backGroundRect = CGRect(x: 0, y: 0, width: width, height: height)
            let backGroundPath = UIBezierPath(rect: backGroundRect)
            backGroundColor.setFill()
            backGroundPath.fill()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: labelColor
            ]
            let textSize = "정보가 없습니다.".size(withAttributes: attributes)
            if textSize.width < backGroundRect.width {
                let textRect = CGRect(x: 0, y: (height - textSize.height) / 2, width: width, height: textSize.height)
                "정보가 없습니다.".draw(in: textRect, withAttributes: attributes)
            }
        }
    }
}
