//
//  Stockfish.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.10.17.
//

import Foundation
import Combine

class StockfishEngine {
    private let wrapper: StockfishWrapper
    var onResponse: (() -> Void)?
    
    init() {
        wrapper = StockfishWrapper()
        wrapper.startEngine()
        wrapper.onResponse = { [weak self] output in
            guard let self = self else { return }
            self.onResponse?()
            NSLog("\(output*100)")
        }
        sendInitCommand()
    }

    private func sendInitCommand() {
        Task {
            await sendCommand("uci")
            await sendCommand("isready")
        }
    }

    func sendCommand(_ command: String) async {
        wrapper.sendCommand(command)
    }
    
    func getEval(fen: String) {
        Task {
            await sendCommand("position fen \(fen);eval")
        }
    }
}
