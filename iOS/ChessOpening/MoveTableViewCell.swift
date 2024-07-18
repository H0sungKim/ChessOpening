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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initializeCell(moveModel: BoardModel.MoveModel, turn: String) {
        switch moveModel.type {
        case 0:
            ivType.image = UIImage(named: "book")
        case 1:
            ivType.image = UIImage(named: "book")
        case 2:
            ivType.image = UIImage(named: "book")
        case 3:
            ivType.image = UIImage(named: "book")
        default:
            ivType.image = UIImage(named: "book")
        }
        lbTitle.text = "\(turn) \(moveModel.pgn) \(moveModel.title)"
        lbInfo.text = moveModel.info
    }
}
