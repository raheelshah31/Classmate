//
//  Constants.swift
//  Classmate
//
//  Created by Raheel Shah on 4/3/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//
import UIKit

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignInToHome = "SignInToHome"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct Theme {
        static let primary = 0x37A2FC
        static let secondary = 0xFF667A
    }
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
        static let senderID = "senderid"
        static let isAnonymous = "isAnonymous"
        static let sentTime = "sentTime"
        static let messageType = "type"
    }
    struct ChatConstants {
        static let chatRoomId = "1" // Hardcoded for now once API are established bring from there
        static let assistanceMessage = "Assistance Requested"
        static let messageTypeAssistance = "2"
        static let messageTypeNormal = "1"
        static let chatRoomDisabledMessage = "This room is disabled by the Moderator"
        static let dateFormatterString = "MMMM dd hh:mm a"
        static let smartReplies = ["Could you please repeat that?","Did not get that?","Nice","What?","How do i get that O/P?","Could you share this on MyCourses?"]
    }
    struct API {
         static let courseURL = "https://a510b7e7-c1aa-408a-89ce-8b7cbda769bf.mock.pstmn.io/courses?id=123456"
         static let busScheduleURL = "https://4304efbc-c6c7-454e-a4e7-84e729f197f0.mock.pstmn.io/busSchedule?home=%22The%20Province%22"
         static let userProfileURL = "https://a510b7e7-c1aa-408a-89ce-8b7cbda769bf.mock.pstmn.io/courses?id=123456"
    }
    struct OnBoarding {
        static let feature1 = "Classmate"
        static let featureDescription1 = "**** No Shying, Just Shining ****"
        static let featureImage1 = UIImage.init(icon: .fontAwesome(.handSpockO), size: CGSize(width: 500  , height: 500))
        static let feature2 = "Anonymous Mode"
        static let featureDescription2 = "Go Anonymous while asking questions in class. No more shying away."
        static let featureImage2 = UIImage.init(icon: .fontAwesome(.userSecret), size: CGSize(width: 500  , height: 500))
        static let feature3 = "Smart Questions"
        static let featureDescription3 = "Ask Questions from a curated list of Questions"
        static let featureImage3 = UIImage.init(icon: .fontAwesome(.lightbulbO), size: CGSize(width: 500  , height: 500))
        static let feature4 = "Assistance"
        static let featureDescription4 = "Need assistance in class? We got you covered. Assistance is just a click away"
        static let featureImage4 = UIImage.init(icon: .fontAwesome(.grav), size: CGSize(width: 500  , height: 500))
        
        static let titleFont = UIFont(name: "Pattaya", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    
    struct FirebaseMessagingURL{
        static let createGroup = "https://fcm.googleapis.com/fcm/notification"
        static let addMember = "https://fcm.googleapis.com/fcm/add"
        static let sendMessage = "https://fcm.googleapis.com/fcm/send"
    }
    struct About {
        static let frameworks = ["Firebase","Alarmofire","SwiftyJSON","SwiftyIcons","Paper Onboarding","Postman Mock Server"]
         static let linkedInURL = "https://www.linkedin.com/in/raheel-shah-18585623/"
         static let stackOverFlowURL = "https://stackoverflow.com/users/6443779/raheel-shah"
         static let gitHubURL = "https://github.com/raheelshah31"
    }
    
    struct Settings {
        static let userAnonymousSetting = "isUserAnonymous"
    }
    
}
