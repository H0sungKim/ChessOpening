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
    var onResponse: ((Float) -> Void)?
    
    init() {
        wrapper = StockfishWrapper()
        wrapper.startEngine()
        wrapper.onResponse = { [weak self] output in
            guard let self = self else { return }
            guard let output = output else { return }
            
            if let eval = self.extractCpValue(output: output) {
                self.onResponse?(eval)
            }
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
            await sendCommand("stop;position fen \(fen);go depth 25")
        }
    }
    private func extractCpValue(output: String) -> Float? {
        if let range = output.range(of: "cp") {
            let substring = output[range.upperBound...].trimmingCharacters(in: .whitespaces)
            
            if let firstWord = substring.split(separator: " ").first, let cpValue = Float(firstWord) {
                return cpValue
            }
        }
        return nil
    }
}
