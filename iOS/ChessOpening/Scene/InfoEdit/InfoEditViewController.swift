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
    
    var openingModel: OpeningModel!
    var turn: String!
    var fen: String!
    
    @IBOutlet weak var tbvInfoEdit: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        tbvInfoEdit.delegate = self
        tbvInfoEdit.dataSource = self
        tbvInfoEdit.dragDelegate = self
        tbvInfoEdit.dropDelegate = self
        tbvInfoEdit.register(UINib(nibName: String(describing: MoveEditTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditTableViewCell.self))
        tbvInfoEdit.register(UINib(nibName: String(describing: MoveEditHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveEditHeaderTableViewCell.self))
        tbvInfoEdit.dragInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        tbvInfoEdit.contentInset.bottom = keyboardFrame.height
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        tbvInfoEdit.contentInset.bottom = 0
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
            
            guard let self = self else { return }
            
            let uuid = UUID().uuidString
            OpeningCommonRepository.shared.setRaw(key: uuid, memo: fen, value: openingModel)
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
        return openingModel.moves.count+1
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
                self?.openingModel.title = newTitle
            }
            cell.infoValueChanged = { [weak self] in
                self?.openingModel.info = cell.tvInfo.text
            }
            cell.initializeCell(openingModel: openingModel)
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
                self?.openingModel.moves[indexPath.row-1].title = newTitle
            }
            cell.infoValueChanged = { [weak self] in
                self?.openingModel.moves[indexPath.row-1].info = cell.tvInfo.text
            }
            cell.onClickSwitch = { [weak self] sender in
                self?.openingModel.moves[indexPath.row-1].valid = sender.isOn
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.onClickMainBookMenu = { [weak self] _ in
                self?.openingModel.moves[indexPath.row-1].type = .mainbook
                self?.tbvInfoEdit.reloadData()
            }
            cell.onClickSideBookMenu = { [weak self] _ in
                self?.openingModel.moves[indexPath.row-1].type = .sidebook
                self?.tbvInfoEdit.reloadData()
            }
            cell.onClickGambitMenu = { [weak self] _ in
                self?.openingModel.moves[indexPath.row-1].type = .gambit
                self?.tbvInfoEdit.reloadData()
            }
            cell.onClickBrilliantMenu = { [weak self] _ in
                self?.openingModel.moves[indexPath.row-1].type = .brilliant
                self?.tbvInfoEdit.reloadData()
            }
            cell.onClickBlunderMenu = { [weak self] _ in
                self?.openingModel.moves[indexPath.row-1].type = .blunder
                self?.tbvInfoEdit.reloadData()
            }
            cell.initializeCell(moveModel: openingModel.moves[indexPath.row-1], turn: turn)
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
        HapticManager.shared.generate()
        let movedObject = openingModel.moves[sourceIndexPath.row-1]
        openingModel.moves.remove(at: sourceIndexPath.row-1)
        openingModel.moves.insert(movedObject, at: destinationIndexPath.row-1)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row == 0 {
            return []
        }
        HapticManager.shared.generate()
        let item = self.openingModel.moves[indexPath.row - 1]
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
                let movedObject = openingModel.moves[sourceIndexPath.row - 1]
                openingModel.moves.remove(at: sourceIndexPath.row - 1)
                openingModel.moves.insert(movedObject, at: destinationIndexPath.row - 1)
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
