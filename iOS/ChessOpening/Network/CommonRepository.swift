//
//  CommonRepository.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.12.
//

import Foundation
import RxSwift
import Moya

class CommonRepository {
    
    static let shared = CommonRepository()
    
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
    
    func getFiltered(key: String) -> Single<BoardModel> {
        return request(CommonRestAPI.getFiltered(key: key))
            .map(BoardEntity.self)
            .map { boardEntity -> BoardModel in
                return BoardModel(boardEntity: boardEntity.convertResponseData())
            }
            .observe(on: MainScheduler.instance)
    }
    
}
