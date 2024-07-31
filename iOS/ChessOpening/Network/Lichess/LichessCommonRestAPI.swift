//
//  LichessCommonRestAPI.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.29.
//

import Foundation
import Moya

enum LichessCommonRestAPI {
    
    case getMastersDatabase(fen: String)
}

extension LichessCommonRestAPI: TargetType {
    var baseURL: URL {
        return URL(string: LichessConfiguration.shared.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMastersDatabase:
            return "masters"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .getMastersDatabase(fen):
            let params: [String: Any] = [
                "fen": fen,
                "moves": 1000,
                "topGames": 0,
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let headerDic: [String: String] = [
            "Content-type" : "application/json;charset=utf-8",
        ]
        return headerDic
    }
}
