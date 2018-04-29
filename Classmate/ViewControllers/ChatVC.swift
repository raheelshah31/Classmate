//
//  ChatVC.swift
//  Classmate
//
//  Created by Raheel Shah on 4/7/18.
//  Copyright © 2018 Raheel Shah. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import Crashlytics
import Alamofire

class ChatVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var assistanceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var kbHeight: CGFloat!
    /**
     * Firebase related variable
     **/
    
    public typealias HTTPHeaders = [String: String]
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var replies: [DataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle!
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    var senderId : String!
    var isAnonymous = UserDefaults.standard.bool(forKey: Constants.Settings.userAnonymousSetting)
    var smartReplies = Constants.ChatConstants.smartReplies
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(RCValues.sharedInstance.string(forKey: .disableChatRoomWithId) == Constants.ChatConstants.chatRoomId){
            self.showAlert(message: Constants.ChatConstants.chatRoomDisabledMessage, title: "")
        }else{
            activityIndicator.startAnimating()
            configureDatabase()
            configureStorage()
            self.message.delegate = self;
            self.message.resignFirstResponder()
            textFieldShouldReturn(self.message)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!isAnonymous){
            switchToAnonymous(assistanceButtonColor: UIColor().UIColorFromHex(rgbValue: UInt32(Constants.Theme.secondary)), sendButtonColor: UIView().tintColor)
            
        }else{
            switchToAnonymous(assistanceButtonColor: UIColor().UIColorFromHex(rgbValue: UInt32(Constants.Theme.primary)), sendButtonColor: .black)
        }
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == chatCollectionView){
            return messages.count
        }else {
            return smartReplies.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == chatCollectionView){
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
            let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
            guard let message = messageSnapshot.value as? [String:String] else { return CGSize.init() }
            let approximateWidthOfContent = view.frame.width
            
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            let estimatedFrame = NSString(string: message[Constants.MessageFields.text]!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            if (self.view.frame.height < 667) {
                return CGSize(width: 300, height: estimatedFrame.height + 90  )
            } else if (self.view.frame.height < 736) {
                
                return CGSize(width: 350, height: estimatedFrame.height + 100)
                
            } else {
                return CGSize(width: 400, height: estimatedFrame.height + 110)
                
            }
        }else {
            return CGSize(width: 150, height: 50  )
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == chatCollectionView){
            let senderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageSent", for: indexPath) as! MessageSentCard
            let receiverCell = collectionView.dequeueReusableCell(withReuseIdentifier: "messegaRecieved", for: indexPath) as! MessageReceivedCard
            let assistanceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "assistanceRequested", for: indexPath) as! AssistanceRequestedCard
            
            let name : String
            let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
            guard let message = messageSnapshot.value as? [String:String] else { return senderCell }
            print("\(senderId)")
            
            // Unpack message from Firebase DataSnapshot
            if(message[Constants.MessageFields.messageType] ==  Constants.ChatConstants.messageTypeAssistance){
                var text = message[Constants.MessageFields.text]
                text = text! + " By : " + message[Constants.MessageFields.name]!
                assistanceCell.assistanceMessage.text = text
                if let time = message[Constants.MessageFields.sentTime] {
                    assistanceCell.assistanceRequestTime.text = time
                }
                assistanceCell.assistanceLeftLabel.setIcon(icon: .fontAwesome(.grav), iconSize: 50, color: UIColor.white, bgColor: .clear)
                
                return assistanceCell
            }else{
                
                if( message[Constants.MessageFields.isAnonymous] == "true"){
                    name = "Anonymous"
                }else {
                    name = message[Constants.MessageFields.name] ?? ""
                }
                let text = message[Constants.MessageFields.text] ?? ""
                if(message[Constants.MessageFields.senderID]  == self.senderId){
                    senderCell.sentMessage?.text = "Me : " + text
                    senderCell.sentLabelTop.text = "Me"
                    senderCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                    senderCell.sentLabel.setIcon(icon: .emoji(.circle), iconSize: 40, color: UIColor.white, bgColor: .clear)
                    if let time = message[Constants.MessageFields.sentTime] {
                        senderCell.time.text = time
                    }
                    return senderCell
                }else{
                    receiverCell.receiverMessage?.text =  name + " : " + text
                    if(name == "Anonymous"){
                        receiverCell.recieverLabelTop.setIcon(icon: .fontAwesome(.userSecret), iconSize: 25, color: UIColor.white, bgColor: .clear)
                    }else{
                        receiverCell.recieverLabelTop.text = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
                    }
                    
                    receiverCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                    receiverCell.recevierLabel.setIcon(icon: .emoji(.circle), iconSize: 40, color: UIColor.black, bgColor: .clear)
                    if let time = message[Constants.MessageFields.sentTime] {
                        receiverCell.time.text = time
                    }
                    return receiverCell
                }
            }
        }else{
            let smartReplyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "smartReplyCell", for: indexPath) as! SmartReplyCell
            smartReplyCell.reply.setTitle(smartReplies[indexPath.row], for: .normal)
            smartReplyCell.reply.tag = indexPath.row
            smartReplyCell.reply.addTarget(self,
                                           action: #selector(self.sendSmartReplies),
                                           for: .touchUpInside)
            smartReplyCell.layer.cornerRadius = 7
            return smartReplyCell
        }
        
    }
    
    @IBAction func assistanceRequested(_ sender: UIButton) {
        var data = [Constants.MessageFields.text: Constants.ChatConstants.assistanceMessage]
        data[Constants.MessageFields.messageType] = Constants.ChatConstants.messageTypeAssistance
        sendMessage(withData: data)
    }
    @IBAction func send(_ sender: Any) {
        var data = [Constants.MessageFields.text: ProfanityFilter.sharedInstance.removeAbuses(message.text!)]
        data[Constants.MessageFields.messageType] = Constants.ChatConstants.messageTypeNormal
        sendMessage(withData: data)
        message.text = ""
    }
    
    
    deinit {
        if (_refHandle) != nil {
            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.chatCollectionView.reloadData()
            self?.activityIndicator.stopAnimating()
            /**
             * Scroll to the last element after reloading
             **/
            self?.scrollView()
            
        })
        self.senderId = Auth.auth().currentUser?.uid
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    
    
    @objc func sendSmartReplies(_ sender : UIButton){
        let data = [Constants.MessageFields.text:  smartReplies[sender.tag]]
        sendMessage(withData: data)
    }
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName
        mdata[Constants.MessageFields.isAnonymous] = String(isAnonymous)
        mdata[Constants.MessageFields.senderID] = senderId
        mdata[Constants.MessageFields.sentTime] = Helper.currentDateTime()
        if let photoURL = Auth.auth().currentUser?.photoURL {
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
        if(!isAnonymous){
            sendNotificationToGroup(message: mdata[Constants.MessageFields.text]!,title :mdata[Constants.MessageFields.name]! )
        }else{
            sendNotificationToGroup(message: mdata[Constants.MessageFields.text]!,title : "Anonymous")
        }
    }
    
    func scrollView() {
        let lastItem = collectionView(self.chatCollectionView, numberOfItemsInSection: 0)-1
        if(lastItem>0){
            let indexPath: NSIndexPath = NSIndexPath.init(item: lastItem, section: 0)
            self.chatCollectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    func switchToAnonymous(assistanceButtonColor : UIColor,sendButtonColor : UIColor){
        self.assistanceButton.setIcon(icon: .fontAwesome(.grav), iconSize: 50, color:  assistanceButtonColor, backgroundColor: .clear, forState: .normal)
        self.sendButton.setIcon(icon: .fontAwesome(.telegram), iconSize: 45, color: sendButtonColor, backgroundColor: .clear, forState: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /**
         * Provide animation to the last cell if it was a Assistance View Cell type
         **/
        let lastItem = self.collectionView(self.chatCollectionView, numberOfItemsInSection: 0)-1
        let indexPathLastCell: NSIndexPath = NSIndexPath.init(item: lastItem, section: 0)
        if(indexPathLastCell as IndexPath == indexPath){
            animateAssistanceLabel(assistanceCell: cell)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Keyboard and View move
    
    /**
     * All the below methods have been used to hide and show keyboard without overlaping or hiding the view behind
     **/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                kbHeight = keyboardSize.height
                self.animateTextField(up: true)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(up: false)
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        UIView.animate(withDuration: 0.3, animations: {
            if (movement != nil){
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement!)
            }
        })
    }
    
    
    func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: goBackToHome))
        self.present(alert, animated: true)
    }
    
    func goBackToHome(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Notification
    
    func sendNotificationToGroup(message : String,title : String){
        let json = "{\"to\": \"\(RCValues.sharedInstance.string(forKey: .notificationKey))\",\"notification\":{\"title\":\"\(title)\",\"body\":\"\(message)\"}}"
        
        let url = URL(string: Constants.FirebaseMessagingURL.sendMessage)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA6onNGfY:APA91bFWq8zN4Pf07mkZZfgml1BEGiDG88VmJBJq-fwXMi9MV_oO4aENLp3-ybbGwOIX6_KYI3fQcKktnB77peAA_ej8s2yH2CBs6NdORu2AP-pVyLYsZ1mVJ8wSphRUgTlKlTmvoSiP", forHTTPHeaderField: "Authorization")
        request.setValue("1007334267382", forHTTPHeaderField: "project_id")
        request.httpBody = jsonData
        
        Alamofire.request(request)
            .responseJSON { response in
                // TODO - handle success and failure report to crashlytics
                print(response.result)
        }
        
        
    }
    
    // MARK - Assistance label animation
    
    func animateAssistanceLabel(assistanceCell : UICollectionViewCell){
        if let lastItem = assistanceCell as? AssistanceRequestedCard {
            UIView.animate(withDuration: 1, delay:0, options: [.repeat, .autoreverse], animations: {
                UIView.setAnimationRepeatCount(4)
                lastItem.assistanceLeftLabel.alpha = 0.2
                lastItem.assistanceLeftLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: {completion in
                lastItem.assistanceLeftLabel.alpha = 1.0
                lastItem.assistanceLeftLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    
    
}
