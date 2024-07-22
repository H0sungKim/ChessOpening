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
        tbvMoves.dragDelegate = self
        tbvMoves.dropDelegate = self
        tbvMoves.register(UINib(nibName: String(describing: MoveEditTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditTableViewCell.self))
        tbvMoves.register(UINib(nibName: String(describing: MoveEditHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditHeaderTableViewCell.self))
        tbvMoves.dragInteractionEnabled = true
        
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
                .subscribe(onSuccess: { [weak self] in
                    let alertDismiss: UIAlertController = UIAlertController(title: "의견을 보내주셔서 감사합니다.", message: "관리자 검토 후 게시해 드리겠습니다.", preferredStyle: .alert)
                    let actionOk: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
                        self?.dismiss(animated: true, completion: nil)
                    })
                    alertDismiss.addAction(actionOk)
                    self?.present(alertDismiss, animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
        })
        alertDismiss.addAction(actionCancel)
        alertDismiss.addAction(actionOk)
        present(alertDismiss, animated: true, completion: nil)
    }
}

extension InfoEditViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
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
            cell.infoValueChanged = { [weak self] in
                self?.boardModel.info = cell.tvInfo.text
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
            cell.infoValueChanged = { [weak self] in
                self?.moveModelsForEdit[indexPath.row-1].info = cell.tvInfo.text
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
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.row == 0 {
            return
        }
        let movedObject = moveModelsForEdit[sourceIndexPath.row-1]
        moveModelsForEdit.remove(at: sourceIndexPath.row-1)
        moveModelsForEdit.insert(movedObject, at: destinationIndexPath.row-1)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row == 0 {
            return []
        }
        let item = self.moveModelsForEdit[indexPath.row - 1]
        let itemProvider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        if destinationIndexPath.row == 0 {
            return
        }
        
        coordinator.items.forEach { dropItem in
            if let sourceIndexPath = dropItem.sourceIndexPath {
                tableView.beginUpdates()
                let movedObject = moveModelsForEdit[sourceIndexPath.row - 1]
                moveModelsForEdit.remove(at: sourceIndexPath.row - 1)
                moveModelsForEdit.insert(movedObject, at: destinationIndexPath.row - 1)
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                tableView.endUpdates()
            }
        }
    }
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        var dropProposal = UITableViewDropProposal(operation: .cancel)
        
        guard session.items.count == 1 else { return dropProposal }
        
        if let destinationIndexPath = destinationIndexPath, destinationIndexPath.row != 0 {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return dropProposal
    }
}
