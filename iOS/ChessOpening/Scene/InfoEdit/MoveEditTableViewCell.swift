//
//  MoveEditTableViewCell.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.19.
//

import UIKit

class MoveEditTableViewCell: UITableViewCell {

    @IBOutlet weak var lbPGN: UILabel!
    @IBOutlet weak var ivType: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var swValid: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvInfo.layer.cornerRadius = 5
        tvInfo.layer.borderWidth = 1
        tvInfo.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    @IBAction func onClickImage(_ sender: Any) {
        
    }
    func initializeCell(moveModelForEdit: MoveModelForEdit, turn: String) {
        switch moveModelForEdit.type {
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
        tfTitle.text = moveModelForEdit.title
        lbPGN.text = "\(turn) \(moveModelForEdit.pgn)"
        tvInfo.text = moveModelForEdit.info
        swValid.isOn = moveModelForEdit.valid
    }
}
