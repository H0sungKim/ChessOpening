//
//  TabBarViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.06.30.
//

import UIKit

class TabBarViewController: UITabBarController {
    var infoViewController: InfoViewController?
    var historyViewController: HistoryViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabInfoViewController = UIViewController.getViewController(viewControllerEnum: .info)
        let tabHistoryViewController = UIViewController.getViewController(viewControllerEnum: .history)
        setViewControllers([tabInfoViewController, tabHistoryViewController], animated: true)
        
        infoViewController = tabInfoViewController as? InfoViewController
        historyViewController = tabHistoryViewController as? HistoryViewController
    }
    
}
