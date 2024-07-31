//
//  CommonRestAPI.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.12.
//

import Foundation
import Moya

enum OpeningCommonRestAPI {
    
    case getFiltered(key: String)
    case setRaw(key: String, memo: String, value: OpeningModel)
}

extension OpeningCommonRestAPI: TargetType {
    var baseURL: URL {
        return URL(string: OpeningConfiguration.shared.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getFiltered:
            return "api/v1/user/filtered/get"
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
        case let .setRaw(key, memo, value):
            let openingEntity: OpeningEntity.OpeningResponseDataEntity = OpeningEntity.OpeningResponseDataEntity(openingModel: value)
            guard let encoded = try? JSONEncoder().encode(openingEntity) else {
                return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
            }
            let encodedStr = String(decoding: encoded, as: UTF8.self)
            let params: [String: Any] = [
                "key": key,
                "memo": memo,
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
