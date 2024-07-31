//
//  InfoViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.06.30.
//

import UIKit

class InfoViewController: UIViewController {

    var integratedOpeningModel: IntegratedOpeningModel!
    var openingModel: OpeningModel = OpeningModel()
    var turn: String = ""
    var sheetHeight: CGFloat!
    weak var delegate: InfoDelegate?
    private var infoEditViewController: UIViewController?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tbvInfo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvInfo.delegate = self
        tbvInfo.dataSource = self
        tbvInfo.register(UINib(nibName: String(describing: MoveTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MoveTableViewCell.self))
        tbvInfo.register(UINib(nibName: String(describing: InfoHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InfoHeaderTableViewCell.self))
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
        if let infoEditViewController = infoEditViewController as? InfoEditViewController {
            infoEditViewController.integratedOpeningModel = integratedOpeningModel
            infoEditViewController.turn = turn
        }
        if let sheet = infoEditViewController?.sheetPresentationController {
            sheet.detents = [.custom { context in
                return self.sheetHeight
            }]
            sheet.prefersGrabberVisible = false
//            sheet.preferredCornerRadius = 0
            sheet.delegate = self
        }
        present(infoEditViewController!, animated: true)
    }
    
    func initializeView() {
        lbTitle.text = openingModel.title
        if openingModel.title == "" {
            lbTitle.text = "정보가 없습니다."
        }
        tbvInfo.reloadData()
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openingModel.moves.count+1
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
            cell.lbInfo.text = openingModel.info
            cell.winRateChartView.drawChart(rate: openingModel.rate)
            return cell
        } else {
            let cell: MoveTableViewCell
            
            if let reusableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoveTableViewCell.self), for: indexPath) as? MoveTableViewCell {
                cell = reusableCell
            } else {
                let objectArray = Bundle.main.loadNibNamed(String(describing: MoveTableViewCell.self), owner: nil, options: nil)
                cell = objectArray![0] as! MoveTableViewCell
            }
            cell.initializeCell(moveModel: openingModel.moves[indexPath.row-1], turn: turn)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return UITableView.automaticDimension
//        }
//        return 80
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.applyMove(pgn: openingModel.moves[indexPath.row-1].pgn)
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
