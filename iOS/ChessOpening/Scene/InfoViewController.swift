//
//  InfoViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.06.30.
//

import UIKit

class InfoViewController: UIViewController {

    var sheetHeight: CGFloat!
    weak var delegate: InfoDelegate?
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
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
    
}

//extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }
//    
//    
//}

protocol InfoDelegate: AnyObject {
    func setPreviousTurn()
    func setNextTurn()
}
