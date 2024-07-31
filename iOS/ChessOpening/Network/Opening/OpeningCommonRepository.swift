//
//  CommonRepository.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.12.
//

import Foundation
import RxSwift
import Moya

class OpeningCommonRepository {
    
    static let shared = OpeningCommonRepository()
    
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
    
    func getFiltered(key: String) -> Single<OptionalOpeningModel> {
        return request(OpeningCommonRestAPI.getFiltered(key: key))
            .map(OpeningEntity.self)
            .map { openingEntity -> OptionalOpeningModel in
                return OptionalOpeningModel(openingEntity: openingEntity.convertResponseData())
            }
            .observe(on: MainScheduler.instance)
    }
    
    func setRaw(key: String, memo: String, value: OpeningModel) -> Single<Void> {
        return request(OpeningCommonRestAPI.setRaw(key: key, memo: memo, value: value))
            .map(VoidEntity.self)
            .map { _ -> Void in
                return Void()
            }
    }
    
}
