//
//  Configuration.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.16.
//

import Foundation

class Configuration {
    public static let shared = Configuration()
    
    var baseUrl: String = "http://218.148.101.148:8081"
    
    private init() {
        
    }
}
