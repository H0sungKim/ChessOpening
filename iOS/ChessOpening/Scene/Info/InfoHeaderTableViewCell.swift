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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
