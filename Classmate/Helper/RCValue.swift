//
//  HomeController.swift
//  Classmate
//
//  Created by Raheel Shah on 4/3/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import Foundation
import Firebase

enum ValueKey: String {
    case feature1Text
    case feature2Text
    case feature3Text
    case feature4Text
    case colorPrimary
    case colorSecondary
    case cardButtontext
    case profanityText
    case disableChatRoomWithId
    case courseUrl
    case busScheduleURL
    case userProfileURL
    case notificationKey
}

class RCValues {
    
    static let sharedInstance = RCValues()
    var loadingDoneCallback: (() -> ())?
    var fetchComplete: Bool = false
    var remoteConfig: RemoteConfig!
    
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        remoteConfig = RemoteConfig.remoteConfig()

        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
    }
    
    func fetchCloudValues() {
        let fetchDuration: TimeInterval = 0
        activateDebugMode()
        remoteConfig.fetch(withExpirationDuration: fetchDuration) {
            [weak self] (status, error) in
            
            guard error == nil else {
                print ("Uh-oh. Got an error fetching remote values \(error)")
                return
            }
            print ("Config Loaded")
            self?.remoteConfig.activateFetched()
            self?.fetchComplete = true
            self?.loadingDoneCallback?()
        }
    }
    
    func activateDebugMode() {
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = debugSettings!
    }
    
    func string(forKey key: ValueKey) -> String {
        return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
}
