//
//  CustomTabBarItem.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.22.
//

import UIKit
import AVFoundation

class AudioManager: NSObject {
    
    let urlMove: URL
    let urlCapture: URL
    
    private var movePlayers: [AVAudioPlayer] = []
    private var capturePlayers: [AVAudioPlayer] = []
    
    static var shared = AudioManager()
    
    private override init() {
        urlMove = Bundle.main.url(forResource: "move", withExtension: "mp3")!
        urlCapture = Bundle.main.url(forResource: "capture", withExtension: "mp3")!
        super.init()
    }
    
    func playMove() {
        do {
            let movePlayer = try AVAudioPlayer(contentsOf: urlMove)
            movePlayer.prepareToPlay()
            movePlayers.append(movePlayer)
            movePlayer.play()
        } catch let error {
            NSLog("\(error)")
        }
    }
    func playCapture() {
        do {
            let capturePlayer = try AVAudioPlayer(contentsOf: urlCapture)
            capturePlayer.prepareToPlay()
            capturePlayers.append(capturePlayer)
            capturePlayer.play()
        } catch let error {
            NSLog("\(error)")
        }
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch player.url {
        case urlMove:
            if let index = movePlayers.firstIndex(of: player) {
                movePlayers.remove(at: index)
            }
        case urlCapture:
            if let index = capturePlayers.firstIndex(of: player) {
                capturePlayers.remove(at: index)
            }
        default:
            return
        }
    }
}
