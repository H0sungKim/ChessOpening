//
//  BoardEntity.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.17.
//

import Foundation

struct OpeningEntity: Codable {
    var responseCode: Int?
    var responseMessage: String?
    var responseData: String?
    
    struct OpeningResponseDataEntity: Codable {
        var title: String?
        var info: String?
        var moves: [MoveEntity]?
        
        struct MoveEntity: Codable {
            var pgn: String?
            var type: Int?
            var title: String?
            var info: String?
            
            init(moveModel: OpeningModel.MoveModel) {
                self.pgn = moveModel.pgn
                self.type = moveModel.type.rawValue
                self.title = moveModel.title
                self.info = moveModel.info
            }
        }
        
        init(openingModel: OpeningModel) {
            self.title = openingModel.title
            self.info = openingModel.info
            self.moves = openingModel.moves.map { MoveEntity(moveModel: $0) }
        }
        
        init() {
            
        }
    }
    
    func convertResponseData() -> OpeningResponseDataEntity {
        guard let responseData = responseData,
              let data = responseData.data(using: .utf8)
        else {
            return OpeningResponseDataEntity()
        }
        guard let openingResponseDataEntity = try? JSONDecoder().decode(OpeningResponseDataEntity.self, from: data) else {
            return OpeningResponseDataEntity()
        }
        return openingResponseDataEntity
    }
}
