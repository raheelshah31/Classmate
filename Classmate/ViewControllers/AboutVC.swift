//
//  AboutVC.swift
//  Classmate
//
//  Created by Raheel Shah on 4/22/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import UIKit
import Firebase

class AboutVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate,InviteDelegate{
    
    @IBOutlet weak var buildVersionLabel: UILabel!
    @IBOutlet weak var frameworksPickerView: UIPickerView!
    @IBOutlet weak var linkedInLabel: UILabel!
    @IBOutlet weak var stackoverflowLabel: UILabel!
    @IBOutlet weak var gitHubLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        frameworksPickerView.dataSource = self
        frameworksPickerView.delegate = self
        linkedInLabel.setIcon(icon: .fontAwesome(.linkedinSquare), iconSize: 40)
        stackoverflowLabel.setIcon(icon: .fontAwesome(.stackOverflow), iconSize: 40)
        gitHubLabel.setIcon(icon: .fontAwesome(.github), iconSize: 40)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.buildVersionLabel.text = "Version : \(version)"
        }
        let stackOverflowtap = UITapGestureRecognizer(target: self, action: #selector(contactInfoTapped))
         let linkedIntap = UITapGestureRecognizer(target: self, action: #selector(contactInfoTapped))
         let gittap = UITapGestureRecognizer(target: self, action: #selector(contactInfoTapped))
        linkedInLabel.isUserInteractionEnabled = true
        linkedInLabel.tag = 0
        linkedInLabel.addGestureRecognizer(linkedIntap)
        stackoverflowLabel.isUserInteractionEnabled = true
        stackoverflowLabel.tag = 1
        stackoverflowLabel.addGestureRecognizer(stackOverflowtap)
        gitHubLabel.isUserInteractionEnabled = true
        gitHubLabel.tag = 2
        gitHubLabel.addGestureRecognizer(gittap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @objc func contactInfoTapped(_ sender : UITapGestureRecognizer){
        print("pressed")
        let label = sender.view as? UILabel
        switch label?.tag {
        case 0 :
            openURL(socialLink: Constants.About.linkedInURL)
        case 1 :
            openURL(socialLink: Constants.About.stackOverFlowURL)
        case 2 :
            openURL(socialLink: Constants.About.gitHubURL)
        default:
            break;
        }
    }
    
    func openURL(socialLink : String){
        if let url = URL(string: socialLink){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.About.frameworks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.About.frameworks[row]
    }
    
    @IBAction func shareApp(_ sender: Any) {
        if let invite = Invites.inviteDialog() {
            invite.setInviteDelegate(self)
            
            // NOTE: You must have the App Store ID set in your developer console project
            // in order for invitations to successfully be sent.
            
            // A message hint for the dialog. Note this manifests differently depending on the
            // received invitation type. For example, in an email invite this appears as the subject.
            invite.setMessage("Try this out!\n -\(String(describing: Auth.auth().currentUser?.displayName))")
            // Title for the dialog, this is what the user sees before sending the invites.
            invite.setTitle("Classmate - Your In class Buddy!!")
            invite.setDeepLink("app_url")
            invite.setCallToActionText("Install!")
            invite.setCustomImage("logo")
            invite.open()
        }
    }
    
    @IBOutlet weak var shareAction: UIButton!
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
