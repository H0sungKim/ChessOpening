//
//  MoveEditHeaderTableViewCell.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.20.
//

import UIKit

class MoveEditHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvInfo: UITextView!
    
    var titleValueChanged: ((_ newTitle: String) -> Void)?
    var infoValueChanged: ((_ newInfo: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfTitle.delegate = self
        tvInfo.delegate = self
        
        tvInfo.layer.cornerRadius = 5
        tvInfo.layer.borderWidth = 1
        tvInfo.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    func initializeCell(boardModel: BoardModel) {
        tfTitle.text = boardModel.title
        tvInfo.text = boardModel.info
    }
}

extension MoveEditHeaderTableViewCell: UITextFieldDelegate {
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

extension MoveEditHeaderTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let oldInfo = textView.text {
            let newInfo = (oldInfo as NSString).replacingCharacters(in: range, with: text)
            infoValueChanged?(newInfo)
        }
        return true
    }
}
