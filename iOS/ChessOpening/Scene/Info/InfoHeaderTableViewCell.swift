//
//  InfoHeaderTableViewCell.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.19.
//

import UIKit

class InfoHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var winRateChartView: WinRateChartView!
    @IBOutlet weak var lbInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
