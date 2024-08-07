//
//  Configuration.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.07.16.
//

import Foundation
import Firebase

class OpeningConfiguration {
    public static let shared = OpeningConfiguration()
    
    var baseURL: String = "http://218.148.101.148:8081"
    
    private init() {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 12
        remoteConfig.configSettings = settings
        
        remoteConfig.setDefaults([
            "base_url": "http://218.148.101.148:8081" as NSObject
        ])
        
        remoteConfig.fetch { [weak self] status, error in
            if status == .success {
                remoteConfig.activate { [weak self] _, _ in
                    self?.baseURL = remoteConfig["base_url"].stringValue ?? "http://218.148.101.148:8081"
                }
            } else {
                if let error = error {
                    NSLog("Hosung.Kim : Error fetching remote config: \(error)")
                }
            }
        }
    }
    
    func getBaseURL() -> String? {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 12
        remoteConfig.configSettings = settings
        
        remoteConfig.setDefaults([
            "base_url": "http://218.148.101.148:8081" as NSObject
        ])
        
        var remoteConfigURL: String?
        remoteConfig.fetch { [weak self] status, error in
            if status == .success {
                remoteConfig.activate { [weak self] _, _ in
                    remoteConfigURL = remoteConfig["base_url"].stringValue
                }
            } else {
                if let error = error {
                    NSLog("Hosung.Kim : Error fetching remote config: \(error)")
                }
            }
        }
        return remoteConfigURL
    }
}
