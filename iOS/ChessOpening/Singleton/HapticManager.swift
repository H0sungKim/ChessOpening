//
//  HapticManager.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.24.
//

import Foundation
import UIKit

class HapticManager {
    
    private let style: UIImpactFeedbackGenerator.FeedbackStyle
    private let generator: UIImpactFeedbackGenerator
    
    static var shared = HapticManager()
    
    private init() {
        style = UIImpactFeedbackGenerator.FeedbackStyle.light
        generator = UIImpactFeedbackGenerator(style: style)
    }
    
    func generate() {
        generator.impactOccurred()
    }
}
