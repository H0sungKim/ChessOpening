//
//  LichessConfiguration.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.29.
//

import Foundation

class LichessConfiguration {
    public static let shared = LichessConfiguration()
    
    var baseURL: String = "https://explorer.lichess.ovh"
    
    private init() {
        
    }
}
