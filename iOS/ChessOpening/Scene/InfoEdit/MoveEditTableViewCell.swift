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
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var swValid: UISwitch!
    
    var titleValueChanged: ((_ newTitle: String) -> Void)?
    var infoValueChanged: ((_ newInfo: String) -> Void)?
    var onClickSwitch: ((_ sender: UISwitch) -> Void)?
    
    var onClickMainBookMenu: ((_ action: UIAction) -> Void)?
    var onClickSideBookMenu: ((_ action: UIAction) -> Void)?
    var onClickGambitMenu: ((_ action: UIAction) -> Void)?
    var onClickBrilliantMenu: ((_ action: UIAction) -> Void)?
    var onClickBlunderMenu: ((_ action: UIAction) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfTitle.delegate = self
        tvInfo.delegate = self
        
        tvInfo.layer.cornerRadius = 5
        tvInfo.layer.borderWidth = 1
        tvInfo.layer.borderColor = UIColor.systemGray6.cgColor
        
        btnImage.showsMenuAsPrimaryAction = true
    }
    @IBAction func valueChangedSwitch(_ sender: UISwitch) {
        onClickSwitch?(sender)
    }
    func initializeCell(moveModelForEdit: MoveModelForEdit, turn: String) {
        ivType.image = moveModelForEdit.type.getImage()
        tfTitle.text = moveModelForEdit.title
        lbPGN.text = "\(turn) \(moveModelForEdit.pgn)"
        tvInfo.text = moveModelForEdit.info
        swValid.isOn = moveModelForEdit.valid
        
        btnImage.menu = UIMenu(title: "Icon을 골라주세요.", identifier: nil, options: .displayInline, children: [
            UIAction(title: MoveType.mainbook.toString(), image: MoveType.mainbook.getImage(), state: moveModelForEdit.type == .mainbook ? .on : .off, handler: onClickMainBookMenu ?? {_ in}),
            UIAction(title: MoveType.sidebook.toString(), image: MoveType.sidebook.getImage(), state: moveModelForEdit.type == .sidebook ? .on : .off, handler: onClickSideBookMenu ?? {_ in}),
            UIAction(title: MoveType.gambit.toString(), image: MoveType.gambit.getImage(), state: moveModelForEdit.type == .gambit ? .on : .off, handler: onClickGambitMenu ?? {_ in}),
            UIAction(title: MoveType.brilliant.toString(), image: MoveType.brilliant.getImage(), state: moveModelForEdit.type == .brilliant ? .on : .off, handler: onClickBrilliantMenu ?? {_ in}),
            UIAction(title: MoveType.blunder.toString(), image: MoveType.blunder.getImage(), state: moveModelForEdit.type == .blunder ? .on : .off, handler: onClickBlunderMenu ?? {_ in}),
        ])
    }
}

extension MoveEditTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldTitle = textField.text {
            let newTitle = (oldTitle as NSString).replacingCharacters(in: range, with: string)
            titleValueChanged?(newTitle)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tvInfo.becomeFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }
    }
}

extension MoveEditTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let oldInfo = textView.text {
            let newInfo = (oldInfo as NSString).replacingCharacters(in: range, with: text)
            infoValueChanged?(newInfo)
        }
        return true
    }
}
