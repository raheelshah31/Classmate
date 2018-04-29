//
//  HomeController.swift
//  Classmate
//
//  Created by Raheel Shah on 4/3/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftIcons

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var isUserAnonymous: UISwitch!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewImage: UIImageView!
    var refresher:UIRefreshControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var courseData = [CourseData]()
    var busSchedule = [BusSchedule]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDefaults()
        getCourses()
        self.navigationItem.titleView = navTitle
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor().UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary))
        self.refresher.addTarget(self, action: #selector(getCourses), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserDefaults()
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(busSchedule.count>0){
            return courseData.count+1
        }else{
            return courseData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (self.view.frame.height < 667) {
            return CGSize(width: 300, height: 160  )
        } else if (self.view.frame.height < 736) {
            
            return CGSize(width: 350, height: 180)
            
        } else {
            return CGSize(width: 400, height: 200)
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cards
        let busScheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! BusScheduleCard
        
        if(indexPath.row <= courseData.count-1){
            let cellData = courseData[indexPath.row]
            cell.courseTitle.text = cellData.courseName
            cell.professorName.text = cellData.courseProffesor
            cell.time.text   = cellData.courseTime
            if (NSString(string: cellData.isActive!)).boolValue {
                // Active|Ongoing Class
                cell.courseImage.setIcon(icon: .dripicon(.lightbulb), textColor: UIColorFromHex(rgbValue: UInt32(Constants.Theme.primary)), backgroundColor: .clear, size: nil)
                cell.courseTitle.textColor = UIColor.black
                cell.professorName.textColor  = UIColor.black
                cell.time.textColor = UIColor.black
                cell.askiInChatButton.isEnabled = true
                cell.askiInChatButton.setTitleColor(UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary)), for: .normal)
                cell.active.setIcon(icon: .icofont(.playAlt1), iconSize: 22, color: UIColorFromHex(rgbValue: 0x00ff66), bgColor: UIColor.white)
                cell.askiInChatButton.tag = indexPath.row
                cell.askiInChatButton.addTarget(self,
                                                action: #selector(self.navigateToChat),
                                                for: .touchUpInside)
                return cell
            }else{
                // Scheduled Class
                cell.courseImage.setIcon(icon: .dripicon(.lightbulb), textColor: UIColor.darkGray, backgroundColor: .clear, size: nil)
                cell.courseTitle.textColor = UIColor.darkGray
                cell.professorName.textColor  = UIColor.darkGray
                cell.time.textColor = UIColor.darkGray
                cell.askiInChatButton.setTitleColor(UIColor.darkGray, for: .disabled)
                cell.askiInChatButton.isEnabled = false
                cell.active.setIcon(icon: .icofont(.time), iconSize: 22, color: UIColor.darkGray, bgColor: .clear)
                return cell
            }
            
        }else{
            /**
             * Card that shows the Schedule of Upcoming bus timings based on the set Home and Destination
             **/
            for stopSchedule in busSchedule{
                if(stopSchedule.stopName == "The Province"){
                    busScheduleCell.arrivalLocation.text = stopSchedule.stopName
                    busScheduleCell.arrivalTimeHome.text = stopSchedule.arrivingInTime
                }else if (stopSchedule.stopName == "Gleason Circle"){
                    busScheduleCell.arrivalTimeDestination.text = stopSchedule.arrivingInTime
                    busScheduleCell.destinationLocation.text = stopSchedule.stopName
                }
            }
            busScheduleCell.busLabel.setIcon(icon: .icofont(.busAlt1), iconSize: 50, color: UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary)), bgColor: .clear)
            busScheduleCell.locationLabel.setIcon(icon: .icofont(.locationPin), iconSize: 20, color: UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary)), bgColor: .clear)
            busScheduleCell.locationLabelRight.setIcon(icon: .icofont(.locationPin), iconSize: 20, color: UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary)), bgColor: .clear)
            return busScheduleCell
        }
        
    }
    
    
    @IBAction func anonymousSwitchValueChanged(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: Constants.Settings.userAnonymousSetting)
        fetchUserDefaults()
    }
    
    func fetchUserDefaults() {
        if defaults.bool(forKey: Constants.Settings.userAnonymousSetting){
            collectionView.backgroundColor = UIColorFromHex(rgbValue: 0x626262,alpha: 1)
            
        }else{
            
            collectionView.backgroundColor = UIColorFromHex(rgbValue: 0xECECEC,alpha: 1)
        }
        isUserAnonymous.setOn(defaults.bool(forKey: Constants.Settings.userAnonymousSetting), animated: true)
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    /**
     *   Make a Call to backend and get the Course data taken by the student
     * In real scenario an id shall be passed for the user to the backend
     **/
    
    @objc func getCourses(){
        //TODO : Make the API call based on user profile student/prof/TA
        var courseURL = ""
        self.courseData = []
        if RCValues.sharedInstance.string(forKey: .courseUrl) != "" {
            courseURL = RCValues.sharedInstance.string(forKey: .courseUrl)
        }else{
            courseURL = Constants.API.courseURL
        }
        self.activityIndicator.startAnimating()
        Alamofire.request(courseURL).validate().responseJSON { response in
            if response.result.isSuccess {
                let json = JSON(response.data!)
                for (key,subJson):(String, JSON) in json["courses"] {
                    var timeSlot = subJson["fromTime"].string
                    timeSlot = timeSlot! + " - " +  subJson["toTime"].string!
                    self.courseData.append(CourseData.init(courseName: subJson["course"].string, courseProffesor: subJson["proffessorName"].string, courseTime: timeSlot , courseKey: subJson["key"].string,isActive: subJson["isActive"].string))
                }
                self.errorView.isHidden = true
                self.refresher.endRefreshing()
                self.collectionView.reloadData()
                self.getBusSchedule()
                self.activityIndicator.stopAnimating()
            }else {
                self.refresher.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.errorView.isHidden = false
                
                self.errorViewImage.setIcon(icon: .icofont(.lightningRay), textColor: self.UIColorFromHex(rgbValue: 0x55EFC4), backgroundColor: .clear, size: nil)
            }
        }
    }
    
    func getBusSchedule(){
        var busScheduleURL = ""
        if RCValues.sharedInstance.string(forKey: .busScheduleURL) != "" {
            busScheduleURL = RCValues.sharedInstance.string(forKey: .busScheduleURL)
        }else{
            busScheduleURL = Constants.API.busScheduleURL
        }
        Alamofire.request(busScheduleURL).validate().responseJSON { response in
            if response.result.isSuccess {
                let json = JSON(response.data!)
                for (key,subJson):(String, JSON) in json["stops"] {
                    self.busSchedule.append(BusSchedule.init(stopName: subJson["stopName"].string, arrivingInTime: subJson["arrivingInTime"].string))
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func navigateToChat(sender : UIButton){
        performSegue(withIdentifier: "showChat", sender: sender)
    }
    
    
    @IBAction func refreshCourses(_ sender: Any) {
        getCourses()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        
        let chatVC  = segue.destination as! ChatVC
        let button = sender as? UIButton
        let courseData = self.courseData[(button?.tag)!]
        chatVC.title = courseData.courseName
    }
    
    
}
