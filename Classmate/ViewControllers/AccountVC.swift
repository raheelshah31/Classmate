//
//  AccountVC.swift
//  Classmate
//
//  Created by Raheel Shah on 4/3/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Alamofire
import SwiftIcons

class AccountVC: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var profileAddress: UILabel!
    @IBOutlet weak var isUserAnonymus: UISwitch!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBAction func anonymousSwitchValueChanged(_ sender: UISwitch) {
        print(sender.isOn)
        defaults.set(sender.isOn, forKey: Constants.Settings.userAnonymousSetting)
    }
    
    
    let avatarImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentSignedInUser = Auth.auth().currentUser
        if currentSignedInUser != nil {
            profileUserName.text = currentSignedInUser?.displayName
            fetchImage(url: (currentSignedInUser?.photoURL)!)
            homeLabel.setIcon(prefixText: " ", icon: .icofont(.uiHome), postfixText: "  Home:", size: 25)
            anonymousLabel.setIcon(prefixText: " ", icon: .icofont(.investigator), postfixText: "  Anonymous:", size: 25)
            // Fetch User Defaults
            fetchUserDefaults()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
         fetchUserDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            /**
             * Very important as when user signs out disconnect from Firebase and Google Sign In
             **/
            try firebaseAuth.signOut()
            if  firebaseAuth.currentUser == nil {
                GIDSignIn.sharedInstance().disconnect()
            }
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    
    func fetchImage(url: URL){
        Alamofire.request(url).responseData { (response) in
            if response.error == nil {
                print(response.result)
                // Show the downloaded image:
                 if let data = response.data {
                    self.profilePicture.image = UIImage(data: data)
                    // Turn the Image view into a circle
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
                    self.profilePicture.clipsToBounds = true
                }
            }
        }
    }
    
    func fetchUserDefaults() {
        isUserAnonymus.setOn(defaults.bool(forKey: Constants.Settings.userAnonymousSetting), animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
