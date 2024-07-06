//
//  UIViewController+Ext.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.04.11.
//

import UIKit

// MARK: - Public Outter Class, Struct, Enum, Protocol
enum ViewControllerEnum: String, CaseIterable {
    case info
    case history
    case infoedit
    case tabbar
}

extension UIViewController {

    // MARK: - Public Method
    class func getViewController(viewControllerEnum: ViewControllerEnum) -> UIViewController {
        switch viewControllerEnum {
        case .info:
            return getViewController(storyboard: "Info", identifier: String(describing: InfoViewController.self), modalPresentationStyle: .automatic)
        case .history:
            return getViewController(storyboard: "History", identifier: String(describing: HistoryViewController.self), modalPresentationStyle: .automatic)
        case .infoedit:
            return getViewController(storyboard: "InfoEdit", identifier: String(describing: InfoEditViewController.self), modalPresentationStyle: .automatic)
        case .tabbar:
            return getViewController(storyboard: "TabBar", identifier: String(describing: TabBarViewController.self), modalPresentationStyle: .automatic)
            
        }
    }
    
    // MARK: - Private Method
    private class func getViewController(storyboard: String, identifier: String, modalPresentationStyle: UIModalPresentationStyle) -> UIViewController {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = modalPresentationStyle
        return vc
    }
}
