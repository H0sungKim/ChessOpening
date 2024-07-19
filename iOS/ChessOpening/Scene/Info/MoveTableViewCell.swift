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
        case GlobalConstant.shared.BOOK:
            ivType.image = UIImage(named: "book")
        case GlobalConstant.shared.GAMBIT:
            ivType.image = UIImage(named: "gambit")
        case GlobalConstant.shared.BRILLIANT:
            ivType.image = UIImage(named: "brilliant")
        case GlobalConstant.shared.BLUNDER:
            ivType.image = UIImage(named: "blunder")
        default:
            ivType.image = UIImage(named: "book")
        }
        lbTitle.text = "\(turn) \(moveModel.pgn) \(moveModel.title)"
        lbInfo.text = moveModel.info
    }
}
