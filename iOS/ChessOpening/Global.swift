//
//  File.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.06.19.
//

import Foundation

public func isValidCoordinate(coordinate: (rank: Int, file: Int)) -> Bool {
    if coordinate.rank < 0 || coordinate.rank > 7 || coordinate.file < 0 || coordinate.file > 7 {
        return false
    }
    return true
}
