//
//  CommonRestAPI.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.12.
//

import Foundation
import Moya

enum CommonRestAPI {
    
    case getFiltered(key: String)
    case setFiltered(key: String, value: BoardModel)
    case getRaw(key: String)
    case setRaw(key: String, value: BoardModel)
}

extension CommonRestAPI: TargetType {
    var baseURL: URL {
        return URL(string: Configuration.shared.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getFiltered:
            return "api/v1/user/filtered/get"
        case .setFiltered:
            return "api/v1/user/filtered/set"
        case .getRaw:
            return "api/v1/user/raw/get"
        case .setRaw:
            return "api/v1/user/raw/set"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .getFiltered(key):
            let params: [String: Any] = [
                "key": key,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .setFiltered(key, value):
            let boardEntity: BoardEntity.BoardResponseDataEntity = BoardEntity.BoardResponseDataEntity(boardModel: value)
            guard let encoded = try? JSONEncoder().encode(boardEntity) else {
                return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
            }
            let encodedStr = String(decoding: encoded, as: UTF8.self)
            let params: [String: Any] = [
                "key": key,
                "value": encodedStr,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .getRaw(key):
            let params: [String: Any] = [
                "key": key,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .setRaw(key, value):
            let boardEntity: BoardEntity.BoardResponseDataEntity = BoardEntity.BoardResponseDataEntity(boardModel: value)
//            NSLog(boardEntity)
            guard let encoded = try? JSONEncoder().encode(boardEntity) else {
//                NSLog("JSON Encoding Error")
                return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
            }
            let encodedStr = String(decoding: encoded, as: UTF8.self)
//            NSLog(encodedStr)
            let params: [String: Any] = [
                "key": key,
                "value": encodedStr,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let headerDic: [String: String] = [
            "Content-type" : "application/json;charset=utf-8",
        ]
        return headerDic
    }
}
