//
//  HistoryViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.01.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var history: [String] = []
    var turn: Int?
    weak var delegate: HistoryDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: HistoryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: HistoryCollectionViewCell.self))
    }
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if history.count%2 == 0 {
            return history.count*3/2
        } else {
            return (history.count-1)*3/2+2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HistoryCollectionViewCell
        if let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HistoryCollectionViewCell.self), for: indexPath) as? HistoryCollectionViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: HistoryCollectionViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! HistoryCollectionViewCell
        }
        cell.backGroundView.backgroundColor = .clear
        if indexPath.row%3 == 0 {
            cell.label.text = "\(indexPath.row/3+1)"
        } else {
            cell.label.text = "\(history[indexPath.row/3*2 + indexPath.row%3-1])"
            if let turn = turn {
                if turn == indexPath.row/3*2 + indexPath.row%3 {
                    cell.backGroundView.backgroundColor = .systemFill
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-1)/10
        if indexPath.row%3 == 0 {
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: width*4, height: width)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 컬랙션뷰 행 하단 여백
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 컬랙션뷰 컬럼 사이 여백
        return collectionView.frame.width/20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row%3 != 0 {
            delegate?.pgnOnClick(turn: indexPath.row/3*2 + indexPath.row%3-1)
        }
    }
}

protocol HistoryDelegate: AnyObject {
    func pgnOnClick(turn: Int)
}
