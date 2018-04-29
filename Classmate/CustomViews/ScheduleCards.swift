//
//  ScheduleCards.swift
//  Classmate
//
//  Created by Raheel Shah on 4/4/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import Foundation
import UIKit

class ScheduleCards: UITableViewCell {
    var message : String?
    var mainImage : UIImage?
    
    var messageView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
