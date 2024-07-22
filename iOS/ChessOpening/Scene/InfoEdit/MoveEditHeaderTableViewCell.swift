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
    var infoValueChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfTitle.delegate = self
        tfTitle.textDropDelegate = self
        tvInfo.delegate = self
        tvInfo.textDropDelegate = self
        tvInfo.isEditable = true
        
        tvInfo.layer.cornerRadius = 5
        tvInfo.layer.borderWidth = 0.5
        tvInfo.layer.borderColor = UIColor.separator.cgColor
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
    func textViewDidChange(_ textView: UITextView) {
        infoValueChanged?()
        invalidateIntrinsicContentSize()
    }
}

extension MoveEditHeaderTableViewCell: UITextDropDelegate {
    func textDroppableView(_ textDroppableView: any UIView & UITextDroppable, proposalForDrop drop: any UITextDropRequest) -> UITextDropProposal {
        return UITextDropProposal(operation: .cancel)
    }
}
