//
//  TabBarViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.06.30.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoViewController = UIViewController.getViewController(viewControllerEnum: .info)
        let historyViewController = UIViewController.getViewController(viewControllerEnum: .history)
        setViewControllers([infoViewController, historyViewController], animated: true)
        
    }
}
