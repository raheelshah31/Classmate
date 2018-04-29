//
//  TabBarVC.swift
//  Classmate
//
//  Created by Raheel Shah on 4/4/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import UIKit
import SwiftIcons

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setting Tab Bar Items
    override func viewWillAppear(_ animated: Bool) {
        tabBar.items?[0].setIcon(icon: .dripicon(.rocket), size: nil, textColor: .lightGray)
        tabBar.items?[1].setIcon(icon: .dripicon(.user), size: nil, textColor: .lightGray)
        tabBar.items?[2].setIcon(icon: .fontAwesome(.vcardO), size: nil, textColor: .lightGray)
       
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
