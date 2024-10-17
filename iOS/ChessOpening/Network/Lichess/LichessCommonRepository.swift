//
//  LichessCommonRepository.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.29.
//

import Foundation
import RxSwift
import Moya
import RxMoya

class LichessCommonRepository {
    
    static let shared = LichessCommonRepository()
    
    private let plugins = [
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ]
    private var networking: MoyaProvider<MultiTarget>
    
    
    private init() {
//        networking = MoyaProvider<MultiTarget>(plugins: plugins)
        networking = MoyaProvider<MultiTarget>()
    }
    
    
    func request(_ target: TargetType) -> Single<Response> {
        return networking.rx.request(.target(target))
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
    }
    
    func getMastersDatabase(fen: String) -> Single<LichessModel> {
        return request(LichessCommonRestAPI.getMastersDatabase(fen: fen))
            .map(LichessEntity.self)
            .map { lichessEntity -> LichessModel in
                return LichessModel(lichessEntity: lichessEntity)
            }
            .observe(on: MainScheduler.instance)
    }
}
