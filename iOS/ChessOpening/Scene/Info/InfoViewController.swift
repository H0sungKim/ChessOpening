//
//  InfoViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.06.30.
//

import UIKit

class InfoViewController: UIViewController {

    var boardModel: BoardModel = BoardModel()
    var turn: String = ""
    var key: String = ""
    var sheetHeight: CGFloat!
    weak var delegate: InfoDelegate?
    private var infoEditViewController: UIViewController?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tbvMoves: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvMoves.delegate = self
        tbvMoves.dataSource = self
        tbvMoves.register(UINib(nibName: String(describing: MoveTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveTableViewCell.self))
        tbvMoves.register(UINib(nibName: String(describing: InfoHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InfoHeaderTableViewCell.self))
        initializeView()
    }
    
    @IBAction func previousOnClick(_ sender: Any) {
        delegate?.setPreviousTurn()
    }
    @IBAction func nextOnClick(_ sender: Any) {
        delegate?.setNextTurn()
    }
    @IBAction func postOnClick(_ sender: Any) {
        infoEditViewController = UIViewController.getViewController(viewControllerEnum: .infoedit)
//        vc.isModalInPresentation = true
        var moveModelsForEdit: [MoveModelForEdit] = boardModel.moves.map { MoveModelForEdit(moveModel: $0) }
        if let legalMovesPGN = delegate?.getLegalMovePGN() {
            for legalMovePGN in legalMovesPGN {
                if !moveModelsForEdit.contains(where: { $0.pgn == legalMovePGN }) {
                    moveModelsForEdit.append(MoveModelForEdit(pgn: legalMovePGN))
                }
            }
        }
        if let infoEditViewController = infoEditViewController as? InfoEditViewController {
            infoEditViewController.boardModel = boardModel
            infoEditViewController.moveModelsForEdit = moveModelsForEdit
            infoEditViewController.turn = turn
            infoEditViewController.key = key
        }
        if let sheet = infoEditViewController?.sheetPresentationController {
            sheet.detents = [.custom { context in
                return self.sheetHeight
            }]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 0
            sheet.delegate = self
        }
        present(infoEditViewController!, animated: true)
    }
    
    func initializeView() {
        lbTitle.text = boardModel.title
        tbvMoves.reloadData()
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardModel.moves.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: InfoHeaderTableViewCell
            
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoHeaderTableViewCell.self), for: indexPath) as? InfoHeaderTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: InfoHeaderTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! InfoHeaderTableViewCell
            }
            cell.lbInfo.text = boardModel.info
            
            return cell
        } else {
            let cell: MoveTableViewCell
            
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoveTableViewCell.self), for: indexPath) as? MoveTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: MoveTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! MoveTableViewCell
            }
            cell.initializeCell(moveModel: boardModel.moves[indexPath.row-1], turn: turn)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.applyMove(pgn: boardModel.moves[indexPath.row-1].pgn)
    }
}

extension InfoViewController: UISheetPresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        infoEditViewController?.view.endEditing(true)
        return false
    }
}

protocol InfoDelegate: AnyObject {
    func setPreviousTurn()
    func setNextTurn()
    func applyMove(pgn: String)
    func getLegalMovePGN() -> [String]
}
