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
    var sheetHeight: CGFloat!
    weak var delegate: InfoDelegate?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbInfo: UILabel!
    @IBOutlet weak var tbvMoves: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvMoves.delegate = self
        tbvMoves.dataSource = self
        tbvMoves.rowHeight = 70
        tbvMoves.register(UINib(nibName: String(describing: MoveTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveTableViewCell.self))
        initializeView()
    }
    @IBAction func previousOnClick(_ sender: Any) {
        delegate?.setPreviousTurn()
    }
    @IBAction func nextOnClick(_ sender: Any) {
        delegate?.setNextTurn()
    }
    @IBAction func postOnClick(_ sender: Any) {
        let vc = UIViewController.getViewController(viewControllerEnum: .infoedit)
                
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { context in
                return self.sheetHeight
            }]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
    }
    
    func initializeView() {
        lbTitle.text = boardModel.title
        lbInfo.text = boardModel.info
        tbvMoves.reloadData()
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardModel.moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MoveTableViewCell
        
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoveTableViewCell.self), for: indexPath) as? MoveTableViewCell {
            cell = reusableCell
        } else {
            let objectArray = Bundle.main.loadNibNamed(String(describing: MoveTableViewCell.self), owner: nil, options: nil)
            cell = objectArray![0] as! MoveTableViewCell
        }
        cell.initializeCell(moveModel: boardModel.moves[indexPath.row], turn: turn)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.applyMove(pgn: boardModel.moves[indexPath.row].pgn)
    }
}

protocol InfoDelegate: AnyObject {
    func setPreviousTurn()
    func setNextTurn()
    func applyMove(pgn: String)
}
