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
    @IBOutlet weak var winRateChartView: WinRateChartView!
    
    var titleValueChanged: ((_ newTitle: String) -> Void)?
    var infoValueChanged: (() -> Void)?
    var onClickSwitch: ((_ sender: UISwitch) -> Void)?
    
    var onClickMainBookMenu: ((_ action: UIAction) -> Void)?
    var onClickSideBookMenu: ((_ action: UIAction) -> Void)?
    var onClickGambitMenu: ((_ action: UIAction) -> Void)?
    var onClickBrilliantMenu: ((_ action: UIAction) -> Void)?
    var onClickBlunderMenu: ((_ action: UIAction) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfTitle.delegate = self
        tfTitle.textDropDelegate = self
        
        tvInfo.delegate = self
        tvInfo.textDropDelegate = self
        tvInfo.isEditable = true
        
        tfTitle.layer.borderColor = UIColor.separator.cgColor
        tfTitle.layer.backgroundColor = UIColor.systemBackground.cgColor
        
        tvInfo.layer.cornerRadius = 5
        tvInfo.layer.borderWidth = 0.5
        tvInfo.layer.borderColor = UIColor.separator.cgColor
        tvInfo.layer.backgroundColor = UIColor.systemBackground.cgColor
        
        btnImage.showsMenuAsPrimaryAction = true
    }
    @IBAction func valueChangedSwitch(_ sender: UISwitch) {
        onClickSwitch?(sender)
    }
    func initializeCell(moveModel: OpeningModel.MoveModel, turn: String) {
        ivType.image = moveModel.valid ? moveModel.type.getImage() : moveModel.type.getGrayImage()
        tfTitle.text = moveModel.title
        lbPGN.text = "\(turn) \(moveModel.pgn)"
        tvInfo.text = moveModel.info
        swValid.isOn = moveModel.valid
        
        btnImage.menu = UIMenu(title: "Icon을 골라주세요.", identifier: nil, options: .displayInline, children: [
            UIAction(title: MoveType.mainbook.toString(), image: MoveType.mainbook.getImage(), state: moveModel.type == .mainbook ? .on : .off, handler: onClickMainBookMenu ?? {_ in}),
            UIAction(title: MoveType.sidebook.toString(), image: MoveType.sidebook.getImage(), state: moveModel.type == .sidebook ? .on : .off, handler: onClickSideBookMenu ?? {_ in}),
            UIAction(title: MoveType.gambit.toString(), image: MoveType.gambit.getImage(), state: moveModel.type == .gambit ? .on : .off, handler: onClickGambitMenu ?? {_ in}),
            UIAction(title: MoveType.brilliant.toString(), image: MoveType.brilliant.getImage(), state: moveModel.type == .brilliant ? .on : .off, handler: onClickBrilliantMenu ?? {_ in}),
            UIAction(title: MoveType.blunder.toString(), image: MoveType.blunder.getImage(), state: moveModel.type == .blunder ? .on : .off, handler: onClickBlunderMenu ?? {_ in}),
        ])
        winRateChartView.drawChart(rate: moveModel.rate)
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
    func textViewDidChange(_ textView: UITextView) {
        infoValueChanged?()
        invalidateIntrinsicContentSize()
    }
}

extension MoveEditTableViewCell: UITextDropDelegate {
    func textDroppableView(_ textDroppableView: any UIView & UITextDroppable, proposalForDrop drop: any UITextDropRequest) -> UITextDropProposal {
        return UITextDropProposal(operation: .cancel)
    }
}
