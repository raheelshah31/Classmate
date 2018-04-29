//
//  OnboardingVC.swift
//  Classmate
//
//  Created by Raheel Shah on 4/6/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class OnboardingVC: UIViewController ,PaperOnboardingDataSource , PaperOnboardingDelegate{
    
    @IBOutlet var skipButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    
    fileprivate var items = [
        OnboardingItemInfo(informationImage: Constants.OnBoarding.featureImage1,
                           title: Constants.OnBoarding.feature1,
                           description: Constants.OnBoarding.featureDescription1,
                           pageIcon: UIImage.init(),
                           color: UIColor().UIColorFromHex(rgbValue: 0x55EFC4),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Constants.OnBoarding.titleFont, descriptionFont: Constants.OnBoarding.descriptionFont),
        
        OnboardingItemInfo(informationImage: Constants.OnBoarding.featureImage2,
                           title: Constants.OnBoarding.feature2,
                           description: Constants.OnBoarding.featureDescription2 ,
                           pageIcon: UIImage.init(),
                           color: UIColor().UIColorFromHex(rgbValue: 0xEF6239),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Constants.OnBoarding.titleFont, descriptionFont: Constants.OnBoarding.descriptionFont),
        
        OnboardingItemInfo(informationImage: Constants.OnBoarding.featureImage3,
                           title: Constants.OnBoarding.feature3,
                           description: Constants.OnBoarding.featureDescription3,
                           pageIcon: UIImage.init(),
                           color: UIColor().UIColorFromHex(rgbValue: 0x2ecc71),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Constants.OnBoarding.titleFont, descriptionFont: Constants.OnBoarding.descriptionFont),
        
        OnboardingItemInfo(informationImage: Constants.OnBoarding.featureImage4,
                           title: Constants.OnBoarding.feature4,
                           description: Constants.OnBoarding.featureDescription4,
                           pageIcon: UIImage.init(),
                           color: UIColor().UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary)),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: Constants.OnBoarding.titleFont, descriptionFont: Constants.OnBoarding.descriptionFont)
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                MeasurementHelper.sendLoginEvent()
                self.performSegue(withIdentifier: Constants.Segues.SignInToHome, sender: nil)
            }else{
                self.skipButton.isHidden = true
                self.setupPaperOnboardingView()
                self.view.bringSubview(toFront: (self.skipButton))
            }
        }
        
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        switch index {
        case 0:
            if(RCValues.sharedInstance.string(forKey: .feature1Text) != ""){
                items[index].description = RCValues.sharedInstance.string(forKey: .feature1Text)
            }
        case 1:
            if(RCValues.sharedInstance.string(forKey: .feature2Text) != ""){
                items[index].description = RCValues.sharedInstance.string(forKey: .feature2Text)
            }
        case 2:
            if(RCValues.sharedInstance.string(forKey: .feature3Text) != ""){
                items[index].description = RCValues.sharedInstance.string(forKey: .feature3Text)
            }
        case 3:
            if(RCValues.sharedInstance.string(forKey: .feature4Text) != ""){
                items[index].description = RCValues.sharedInstance.string(forKey: .feature4Text)
            }
        default:
            break
        }
        
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
    
    @IBAction func skipButtonTapped(_: UIButton) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 3 ? false : true
    }
    
    
}

// MARK: Actions

extension OnboardingVC {
    
    
}


