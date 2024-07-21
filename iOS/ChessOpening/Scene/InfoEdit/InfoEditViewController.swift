//
//  InfoEditViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.01.
//

import UIKit
import RxSwift

class InfoEditViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    var boardModel: BoardModel = BoardModel()
    var moveModelsForEdit: [MoveModelForEdit] = []
    var turn: String = ""
    var key: String = ""
    
    @IBOutlet weak var tbvMoves: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        tbvMoves.delegate = self
        tbvMoves.dataSource = self
        tbvMoves.register(UINib(nibName: String(describing: MoveEditTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditTableViewCell.self))
        tbvMoves.register(UINib(nibName: String(describing: MoveEditHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditHeaderTableViewCell.self))
    }
    @IBAction func onClickBack(_ sender: Any) {
        let alertDismiss: UIAlertController = UIAlertController(title: "창을 닫으시겠습니까?", message: "작성 중이던 내용은 저장되지 않습니다.", preferredStyle: .alert)
        let actionCancel: UIAlertAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let actionOk: UIAlertAction = UIAlertAction(title: "예", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        alertDismiss.addAction(actionCancel)
        alertDismiss.addAction(actionOk)
        present(alertDismiss, animated: true, completion: nil)
    }
    @IBAction func onClickPost(_ sender: Any) {
        let alertDismiss: UIAlertController = UIAlertController(title: "이대로 게시하시겠습니까?", message: "", preferredStyle: .alert)
        let actionCancel: UIAlertAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let actionOk: UIAlertAction = UIAlertAction(title: "예", style: .default, handler: { [weak self] _ in
            let alertDismiss: UIAlertController = UIAlertController(title: "의견을 보내주셔서 감사합니다.", message: "관리자 검토 후 게시해 드리겠습니다.", preferredStyle: .alert)
            let actionOk: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            alertDismiss.addAction(actionOk)
            self?.present(alertDismiss, animated: true, completion: nil)
            
            guard let self = self else {
                return
            }
            
            var moves: [BoardModel.MoveModel] = []
            for moveModelForEdit in self.moveModelsForEdit {
                if moveModelForEdit.valid {
                    moves.append(BoardModel.MoveModel(moveModelForEdit: moveModelForEdit))
                }
            }
            boardModel.moves = moves
            
            CommonRepository.shared.setRaw(key: self.key, value: boardModel)
                .subscribe(onSuccess: {
                })
                .disposed(by: disposeBag)
        })
        alertDismiss.addAction(actionCancel)
        alertDismiss.addAction(actionOk)
        present(alertDismiss, animated: true, completion: nil)
    }
}


extension InfoEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moveModelsForEdit.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MoveEditHeaderTableViewCell
            
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoveEditHeaderTableViewCell.self), for: indexPath) as? MoveEditHeaderTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: MoveEditHeaderTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! MoveEditHeaderTableViewCell
            }
            cell.titleValueChanged = { [weak self] newTitle in
                self?.boardModel.title = newTitle
            }
            cell.infoValueChanged = { [weak self] newInfo in
                self?.boardModel.info = newInfo
            }
            cell.initializeCell(boardModel: boardModel)
            return cell
        } else {
            let cell: MoveEditTableViewCell
            
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoveEditTableViewCell.self), for: indexPath) as? MoveEditTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: MoveEditTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! MoveEditTableViewCell
            }
            cell.titleValueChanged = { [weak self] newTitle in
                self?.moveModelsForEdit[indexPath.row-1].title = newTitle
            }
            cell.infoValueChanged = { [weak self] newInfo in
                self?.moveModelsForEdit[indexPath.row-1].info = newInfo
            }
            cell.onClickSwitch = { [weak self] sender in
                self?.moveModelsForEdit[indexPath.row-1].valid = sender.isOn
            }
            cell.onClickMainBookMenu = { [weak self] _ in
                self?.moveModelsForEdit[indexPath.row-1].type = .mainbook
                self?.tbvMoves.reloadData()
            }
            cell.onClickSideBookMenu = { [weak self] _ in
                self?.moveModelsForEdit[indexPath.row-1].type = .sidebook
                self?.tbvMoves.reloadData()
            }
            cell.onClickGambitMenu = { [weak self] _ in
                self?.moveModelsForEdit[indexPath.row-1].type = .gambit
                self?.tbvMoves.reloadData()
            }
            cell.onClickBrilliantMenu = { [weak self] _ in
                self?.moveModelsForEdit[indexPath.row-1].type = .brilliant
                self?.tbvMoves.reloadData()
            }
            cell.onClickBlunderMenu = { [weak self] _ in
                self?.moveModelsForEdit[indexPath.row-1].type = .blunder
                self?.tbvMoves.reloadData()
            }
            cell.initializeCell(moveModelForEdit: moveModelsForEdit[indexPath.row-1], turn: turn)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        return 120
//        return UITableView.automaticDimension
    }
}
