//
//  MoveTableViewCell.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.18.
//

import UIKit

class MoveTableViewCell: UITableViewCell {

    @IBOutlet weak var ivType: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbInfo: UILabel!
    @IBOutlet weak var winRateChartView: WinRateChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initializeCell(moveModel: OpeningModel.MoveModel, turn: String) {
        ivType.image = moveModel.type.getImage()
        lbTitle.text = "\(turn) \(moveModel.pgn) \(moveModel.title)"
        lbInfo.text = moveModel.info
        winRateChartView.drawChart(rate: moveModel.rate)
    }
}
