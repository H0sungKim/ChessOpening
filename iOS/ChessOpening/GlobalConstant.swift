//
//  GlobalConstant.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.18.
//

import Foundation

class GlobalConstant {
    
    static let shared: GlobalConstant = GlobalConstant()
    
    private init() {
        
    }
    
    let BOOK = 0
    let GAMBIT = 1
    let BRILLIANT = 2
    let BLUNDER = 3
}
