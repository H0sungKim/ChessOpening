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
    @IBOutlet weak var winRateChartView: WinRateChartView!
    
    var titleValueChanged: ((_ newTitle: String) -> Void)?
    var infoValueChanged: (() -> Void)?
    
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
    }
    
    func initializeCell(openingModel: OpeningModel) {
        tfTitle.text = openingModel.title
        tvInfo.text = openingModel.info
        winRateChartView.drawChart(rate: openingModel.rate)
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
