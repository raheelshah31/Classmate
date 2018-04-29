//
//  File.swift
//  Classmate
//
//  Created by Raheel Shah on 4/18/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import Foundation

class Helper {
    static func currentDateTime() -> String {
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.dateFormat = Constants.ChatConstants.dateFormatterString
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
    }
}
