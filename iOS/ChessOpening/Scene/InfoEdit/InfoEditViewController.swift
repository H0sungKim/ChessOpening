//
//  InfoEditViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.01.
//

import UIKit

class InfoEditViewController: UIViewController {
    
    var boardModel: BoardModel = BoardModel()
    var moveModelsForEdit: [MoveModelForEdit] = []
    var turn: String = ""
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var tbvMoves: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvInfo.layer.cornerRadius = 5
        tvInfo.layer.borderWidth = 1
        tvInfo.layer.borderColor = UIColor.systemGray6.cgColor
        
        tfTitle.text = boardModel.title
        tvInfo.text = boardModel.info
        
        tbvMoves.delegate = self
        tbvMoves.dataSource = self
        tbvMoves.rowHeight = 100
        tbvMoves.register(UINib(nibName: String(describing: MoveEditTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditTableViewCell.self))
    }
    @IBAction func onClickBack(_ sender: Any) {
        let alertDismiss: UIAlertController = UIAlertController(title: "창을 닫으시겠습니까?", message: "작성 중이던 내용은 저장되지 않습니다.", preferredStyle: .alert)
        let actionCancel: UIAlertAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let actionOk: UIAlertAction = UIAlertAction(title: "예", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alertDismiss.addAction(actionCancel)
        alertDismiss.addAction(actionOk)
        present(alertDismiss, animated: true, completion: nil)
    }
    @IBAction func onClickPost(_ sender: Any) {
        
        let alertDismiss: UIAlertController = UIAlertController(title: "이대로 게시하시겠습니까?", message: "", preferredStyle: .alert)
        let actionCancel: UIAlertAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let actionOk: UIAlertAction = UIAlertAction(title: "예", style: .default, handler: { _ in
            let alertDismiss: UIAlertController = UIAlertController(title: "의견을 보내주셔서 감사합니다.", message: "관리자 검토 후 게시해 드리겠습니다.", preferredStyle: .alert)
            let actionOk: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            alertDismiss.addAction(actionOk)
            self.present(alertDismiss, animated: true, completion: nil)
        })
        alertDismiss.addAction(actionCancel)
        alertDismiss.addAction(actionOk)
        present(alertDismiss, animated: true, completion: nil)
    }
}


extension InfoEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moveModelsForEdit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MoveEditTableViewCell
        
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoveEditTableViewCell.self), for: indexPath) as? MoveEditTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: MoveEditTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! MoveEditTableViewCell
        }
        cell.initializeCell(moveModelForEdit: moveModelsForEdit[indexPath.row], turn: turn)
        
        return cell
    }
}
