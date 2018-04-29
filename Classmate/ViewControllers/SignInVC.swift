//
//  SignInVC.swift
//  Classmate
//
//  Created by Raheel Shah on 4/3/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//


import UIKit

import Firebase
import GoogleSignIn
import SwiftIcons

class SignInVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    var remoteConfig: RemoteConfig!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        configureRemoteConfig()
        fetchConfig()

        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                MeasurementHelper.sendLoginEvent()
                self.performSegue(withIdentifier: Constants.Segues.SignInToHome, sender: nil)
            }
        }
    }
    
    func fetchConfig() {
        var expirationDuration: TimeInterval = 3600
        // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
        // the server.
        if self.remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
        // fetched and cached config would be considered expired because it would have been fetched
        // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
        // throttling is in progress. The default expiration duration is 43200 (12 hours).
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
            if status == .success {
                print("Config fetched!")
                guard let strongSelf = self else { return }
                strongSelf.remoteConfig.activateFetched()
                let isSignInEnabled = strongSelf.remoteConfig["isSignInEnabled"]
                if isSignInEnabled.source != .static {
                    if(isSignInEnabled.boolValue){
                        self?.signInButton.isHidden = false
                    }else{
                        self?.signInButton.isHidden = true
                    }
                }
            } else {
                print("Config not fetched")
                if let error = error {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        // Create Remote Config Setting to enable developer mode.
        // Fetching configs from the server is normally limited to 5 requests per hour.
        // Enabling developer mode allows many more requests to be made per hour, so developers
        // can test different config values during development.
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
