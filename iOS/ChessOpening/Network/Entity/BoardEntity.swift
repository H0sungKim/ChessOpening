//
//  BoardEntity.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.17.
//

import Foundation

struct BoardEntity: Codable {
    var responseCode: Int?
    var responseMessage: String?
    var responseData: String?
    
    struct BoardResponseDataEntity: Codable {
        var title: String?
        var info: String?
        var moves: [MoveEntity]?
        
        struct MoveEntity: Codable {
            var pgn: String?
            var type: Int?
            var title: String?
            var info: String?
        }
    }
    
    func convertResponseData() -> BoardResponseDataEntity {
        guard let responseData = responseData,
              let data = responseData.data(using: .utf8)
        else {
            return BoardResponseDataEntity()
        }
        guard let boardResponseDataEntity = try? JSONDecoder().decode(BoardResponseDataEntity.self, from: data) else {
            return BoardResponseDataEntity()
        }
        return boardResponseDataEntity
    }
}
