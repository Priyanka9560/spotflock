//
//  NewsFeedTableViewCell.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 26/09/19.
//  Copyright © 2019 Priyanka Bandaru. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var likeIcon: UILabel!
    @IBOutlet weak var commentIcon: UILabel!
    @IBOutlet weak var shareIcon: UILabel!
    
    @IBOutlet weak var newsFeedImage: UIImageView!
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var shareCount: UILabel!
    
    
    var newsFeedObject : ParserStruct.dashboardStruct! {
        didSet{
            updateTableViewCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UISetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func UISetup() {

        DispatchQueue.main.async(execute: {() -> Void in
            
            self.backGroundView.layer.cornerRadius = 10.0
            self.backGroundView.layer.masksToBounds = true
        
            self.backGroundView.layer.borderColor = UIColor.lightGray.cgColor;
            self.backGroundView.layer.borderWidth = 0.5
            

        
        });
        
    }
    
    
    func updateTableViewCellData(){
        
        DispatchQueue.main.async(execute: {() -> Void in
            
            self.titleLabel.text = self.newsFeedObject.title;
            self.descriptionLabel.text = self.newsFeedObject.short_description;
            
            if self.newsFeedObject.description_image_url != "" {
                let url : NSURL = NSURL(string: self.newsFeedObject.description_image_url)!
                self.newsFeedImage.tag = self.newsFeedObject.id + 1000
                self.setupImage(self.newsFeedObject.description_image_url , messageId: url.lastPathComponent!, decisionString: self.newsFeedObject.id + 1000 , mimeType: "", cellImgView: (self.newsFeedImage)!)
            }
 
            if self.newsFeedObject.title_image_url != "" {
                let url : NSURL = NSURL(string: self.newsFeedObject.title_image_url)!
                self.titleImageView.tag = self.newsFeedObject.id + 2000
                self.setupImage(self.newsFeedObject.title_image_url , messageId: url.lastPathComponent!, decisionString: 2000 , mimeType: "", cellImgView: (self.titleImageView)!)
            }
        })
    }
    
    func setupImage(_ imageUrl: String, messageId: String, decisionString indexTag: Int ,mimeType : String ,cellImgView: UIImageView) {
        
        if fileExistanceCheck(fileName: messageId ,indexTag: indexTag ,mimeType: mimeType, cellImgView: cellImgView) {
            
        }
        else {
            DispatchQueue.global(qos: .userInitiated).async {
                AppHelpers.downloadImage(with: URL(string: imageUrl)!, completionBlock: {(_ completed: Bool, _ image: UIImage?, _ error: Error?, _ data: Data) -> Void in
                    if completed {
                        DispatchQueue.main.async(execute: {() -> Void in
                            if data.count > 0 && image != nil {
                                AppHelpers.dataStoreToFilePath(with: data, fileName: "\(messageId)")
                                DispatchQueue.main.async(execute: {() -> Void in
                                    if indexTag == cellImgView.tag {
                                        cellImgView.image = UIImage(data: data )
                                    }else{
                                        cellImgView.image = UIImage(named: "defaultImage")
                                    }
                                })
                            }
                        })
                    }
                } )
            }
        }
    }
    
    func fileExistanceCheck(fileName str:String ,indexTag: Int ,mimeType : String ,cellImgView: UIImageView) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        
        let filePath = url.appendingPathComponent(str).path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            
            do {
                if indexTag == cellImgView.tag {
                    
                    try cellImgView.image = UIImage(data: Data(contentsOf: URL(fileURLWithPath: filePath)) )
                }else{
                    cellImgView.image = UIImage(named: "defaultImage")
                }
            } catch let error as NSError {
                print("Failed writing to URL: \(filePath), Error: " + error.localizedDescription)
            }
            return true
        } else {
            
            return false
        }
        
    }
    
    func removeFileWithLastComponent(lastComp : String) {
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        
        let filePath = url.appendingPathComponent(lastComp).path
        
        if lastComp != ""  && fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
                print("file removed successfully")
            } catch let error as NSError {
                print("Failed writing to URL: \(filePath), Error: " + error.localizedDescription)
            }
        }
        
    }
    
}
