//
//  JsonParser.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 27/09/19.
//

import UIKit

class JsonParser: NSObject {
    
    class var sharedInstance: JsonParser
    {
        struct Static
        {
            static let instance: JsonParser = JsonParser()
        }
        return Static.instance
    }
    
    func convertKstreamResponseToJson(reponseObj: Array<NSDictionary>) -> NSMutableArray {
        let mainArray = reponseObj
        let responseArray : NSMutableArray = []
        if mainArray.count != 0 {
            for objDict: NSDictionary in mainArray {
                
                var serviceStruct = ParserStruct.dashboardStruct()
                serviceStruct.id = JsonConverter.sharedInstance.nullConditionForInt(intValue: objDict.value(forKey: "id") as Any)
                serviceStruct.rss_source_id =  JsonConverter.sharedInstance.nullConditionForInt(intValue: objDict.value(forKey: "rss_source_id") as Any)
                serviceStruct.title = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "title") as Any)
                serviceStruct.full_description = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "full_description") as Any)
                serviceStruct.short_description = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "short_description") as Any)
                serviceStruct.title_image = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "title_image") as Any)
                
                serviceStruct.tag_line = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "tag_line") as Any)
                serviceStruct.title_image_url = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "title_image_url") as Any)
                serviceStruct.description_image_url = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "description_image_url") as Any)
                serviceStruct.article_url = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "article_url") as Any)
                
                serviceStruct.tag_line = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "tag_line") as Any)
                serviceStruct.title_image_url = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "title_image_url") as Any)
                
                serviceStruct.description_image_url = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "description_image_url") as Any)
                serviceStruct.article_url = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "article_url") as Any)
                serviceStruct.author = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "author") as Any)
                serviceStruct.article_type = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "article_type") as Any)
                
                serviceStruct.published_date = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "published_date") as Any)
                
                serviceStruct.is_sponsored = JsonConverter.sharedInstance.nullConditionForBool(boolValue: objDict.value(forKey: "is_sponsored") as Any)
                serviceStruct.is_premium = JsonConverter.sharedInstance.nullConditionForBool(boolValue: objDict.value(forKey: "is_premium") as Any)
                serviceStruct.tags = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "tags") as Any)
                serviceStruct.likes = JsonConverter.sharedInstance.nullConditionForInt(intValue: objDict.value(forKey: "likes") as Any)
                serviceStruct.shares = JsonConverter.sharedInstance.nullConditionForInt(intValue: objDict.value(forKey: "shares") as Any)
                
                serviceStruct.accepted = JsonConverter.sharedInstance.nullConditionForBool(boolValue: objDict.value(forKey: "accepted") as Any)
                serviceStruct.meta_kstream_id = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "meta_kstream_id") as Any)
                serviceStruct.created_at = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "updated_at") as Any)
                serviceStruct.created_at = JsonConverter.sharedInstance.nullConditionForString(str: objDict.value(forKey: "updated_at") as Any)
                
                //                if serviceStruct.storeImage != "" {
                //                    let url : NSURL = NSURL(string: serviceStruct.storeImage)!
                //                    removeFileWithLastComponent(lastComp: url.lastPathComponent!)
                //                }
                
                responseArray.add(serviceStruct)
            }
        }
        return responseArray
    }

// Parsing of Login data
    
 /*   func getLoginData(resultObj:NSDictionary) -> structLoginInfo
    {
        let objStruct = structLoginInfo()
        
        let dicResponse = nullConditionForDictionary(dict: resultObj)

        if dicResponse.count > 0 {
            
            let arrDevicesObj = nullConditionForArray(array: dicResponse["devices"] as Any) as NSArray
            
            if arrDevicesObj.count > 0 {
                
                for  dic: Any in arrDevicesObj
                {
                    if dic is NSDictionary
                    {
                        let dicData = dic as! NSDictionary
                        
                        objStruct.arrDevices.add(ParseDevices(dicData: dicData))
                    }
                }
            }
            else
            {
                let dicDevicesObj = nullConditionForDictionary(dict: dicResponse["devices"] as Any) as NSDictionary
                
                if dicDevicesObj.count > 0 {
                    
                    objStruct.arrDevices.add(ParseDevices(dicData: dicDevicesObj))
                }
                else {
                    //                    showToastWithMessage(message: "No devices found")
                }
                
            }
            



            let arrPlacesObj = nullConditionForArray(array: dicResponse["places"] as Any) as NSArray
            
            if arrPlacesObj.count > 0 {
                
                for  dic: Any in arrPlacesObj
                {
                    if dic is NSDictionary
                    {
                        let dicData = dic as! NSDictionary
                        
                        objStruct.arrPlaces .add(ParsePlaces(dicData: dicData))
                    }
                }
            }
            else
            {
                let dicPlacesObj = nullConditionForDictionary(dict: dicResponse["places"] as Any) as NSDictionary
                
                if dicPlacesObj.count > 0 {
                    
                    objStruct.arrPlaces .add(ParsePlaces(dicData: dicPlacesObj))
                }
                else {
                    //                    showToastWithMessage(message: "No places found")
                }
                
            }

            
            
            let arrUserInfoObj = nullConditionForArray(array: dicResponse["userInfo"] as Any) as NSArray
            
            if arrUserInfoObj.count > 0 {
                
                for  dic: Any in arrUserInfoObj
                {
                    if dic is NSDictionary
                    {
                        let dicData = dic as! NSDictionary
                        
                        objStruct.arrUserInfo .add(ParseUserInfo(dicData: dicData))
                    }
                }
            }
            else
            {
                let dicUserInfoObj = nullConditionForDictionary(dict: dicResponse["userInfo"] as Any) as NSDictionary
                
                if dicUserInfoObj.count > 0 {
                    
                    objStruct.arrUserInfo .add(ParseUserInfo(dicData: dicUserInfoObj))
                }
                else {
                    //                    showToastWithMessage(message: "No userinfo found")
                }
                
            }
            
            
            let arrGuestsObj = nullConditionForArray(array: dicResponse["guests"] as Any) as NSArray
            
            if arrGuestsObj.count > 0 {
                
                for  dic: Any in arrGuestsObj
                {
                    if dic is NSDictionary
                    {
                        let dicData = dic as! NSDictionary
                        
                        objStruct.arrGuests .add(ParseGuests(dicData: dicData))
                    }
                }
            }
            else
            {
                let dicGuestsObj = nullConditionForDictionary(dict: dicResponse["guests"] as Any) as NSDictionary
                
                if dicGuestsObj.count > 0 {
                    
                    objStruct.arrGuests .add(ParseGuests(dicData: dicGuestsObj))
                }
                else {
                    //                    showToastWithMessage(message: "No guests found")
                }
                
            }
            
            
            CoreDataManager.sharedInstance.saveLoginData(objStruct) { (_ completed: Bool) -> Void in
                print("LoginData saved===>> 1",completed)
            }
            
        }
        return objStruct
    }*/
    
}
