//
//  CollectionViewCell.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.10.
//

import Foundation
import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        backGroundView.layer.cornerRadius = 5
    }
}
