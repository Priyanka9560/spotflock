//
//  KStreamViewController.swift
//  SpotflockAssignment
//
//  Created by Dutta Priyanka Bandarua Brahma on 26/09/19.
//  Copyright © 2019 Priyanka Bandaru. All rights reserved.
//

import UIKit

class KStreamViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var newsfeedTableView: UITableView!
    
    var newsFeedArray : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        dataSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ServerCallKstream()
        
        loadNibs();
    }
    
    func loadNibs() {
//        self.newsfeedTableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: "NewsFeedTableViewCell")
        
        newsfeedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsFeedTableViewCell")
    }
    
    func dataSetup() {
        //nameLabel.text = "Name : \(getUserDefaults(with: USER_NAME))"
        //emailLabel.text = "Email : \(getUserDefaults(with: USER_EMAIL))"
    }
    

    @IBAction func logoutBtnAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title:nil, message:"Are you sure you want to log out ?", preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title:"Cancel", style:.cancel, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title:"Log Out", style:.destructive, handler: { (action) in
            clearUserDefaults()
            APP_DELEGATE.setRootWindowWithIdentifier(identifier: "login")
        }))
        self.present(alert, animated:true, completion:nil)
    }
    
    // Service Calls
    func ServerCallKstream() {
        
        if !checkNet() {
            showToastWithMessage(message: no_Internet_Connection)
            return
        }
        
        let loader = showLoader(message: "Loading...")
        
        APIs.sharedInstance.Service_Call(withParameters: nil, withMethodName: .DashboardFeed, complitionHandler: {(_ response: Any, _ error: Error?, _ isSuccess: Bool) -> Void in
            
            DispatchQueue.main.async(execute: {() -> Void in
                hideLoader(loader: loader)
                
             
                let dicResponse : NSDictionary = nullConditionForDictionary(dict: response) as NSDictionary
                
                print("ongoingOrdersArray - \(dicResponse)")
                
//                let d: NSDictionary = dicResponse.value(forKey: "kstream") as! NSDictionary
                
                if isSuccess {
                    
                    let streamObj:NSDictionary =  JsonConverter.sharedInstance.nullConditionForDictionary(dict: dicResponse.value(forKey: "kstream") as Any) as NSDictionary;
                    
                    let dataArray:NSArray =  JsonConverter.sharedInstance.nullConditionForArray(array: streamObj.value(forKey: "data") as Any) as NSArray;
                    
                    
                    
                    self.newsFeedArray = JsonParser.sharedInstance.convertKstreamResponseToJson(reponseObj: JsonConverter.sharedInstance.nullConditionForArray(array: dataArray as Any) as! Array<NSDictionary>)
                                        
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.newsfeedTableView.reloadData()
                    })
                    if self.newsFeedArray.count > 0 {
                        print("Response In Dashboard : ",self.newsFeedArray)
                    }
                    else {
                        showToastWithMessage(message: "Something went wrong. Try again")
                    }
                }
                else {
                    showToastWithMessage(message: nullConditionForString(str: dicResponse.value(forKey: "message") as Any))
                }
            })
            
        })
    }
}

extension KStreamViewController : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsFeedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell") as? NewsFeedTableViewCell
        
        cell!.newsFeedObject = self.newsFeedArray[indexPath.row] as? ParserStruct.dashboardStruct
      
        cell?.selectionStyle = .none
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        }
    
}
