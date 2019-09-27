//
//  JsonConverter.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 27/09/19.
//

import UIKit

class JsonConverter: NSObject {
    
    class var sharedInstance: JsonConverter
    {
        struct Static
        {
            static let instance: JsonConverter = JsonConverter()
        }
        return Static.instance
    }
    
    func convertRegisterObject(toJson objStruct:ParserStruct.structLoginAndRegister) -> Data
    {

        var maindic = [String:String]()
        maindic["name"] = objStruct.name
        maindic["email"] = objStruct.email
        maindic["password"] = objStruct.password
        maindic["password_confirmation"] = objStruct.password_confirmation
        maindic["mobile"] = objStruct.mobile
        maindic["gender"] = objStruct.gender
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(maindic)
        
        return data
    }

    func convertLoginObject(toJson objStruct: ParserStruct.structLoginAndRegister) -> Data
    {
        var maindic = [String:Any]()
        maindic["email"] = objStruct.email
        maindic["password"] = objStruct.password
        
        
     let data = try! JSONSerialization.data(withJSONObject: maindic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        return data
    }
    

    // MARK:- String Null check Validation
    
    func nullConditionForString(str : Any) -> String {
        
        if let value = str as? String {
            if(str as? String == "null" || str as? String == "<null>"){
                return ""
            }
            return value
        }else{
            return ""
        }
    }
    
    // MARK:- Bool Null check Validation
    
    func nullConditionForBool(boolValue : Any) -> Bool {
        if let value = boolValue as? Bool {
            return value
        }else{
            return false
        }
    }
    
    // MARK:- Array Null check Validation
    
    func nullConditionForArray(array : Any) -> Array<Any> {
        if let value = array as? Array<Any> {
            return value
        }else{
            return []
        }
    }
    
    // MARK:- Int Null check Validation
    
    func nullConditionForInt(intValue : Any) -> Int {
        if let value = intValue as? Int {
            return value
        }else{
            return 0
        }
    }
    
    // MARK:- Double Null check Validation
    
    func nullConditionForDouble(doubleValue : Any) -> Double {
        if let value = doubleValue as? Double {
            return value
        }else{
            return 0
        }
    }
    
    // MARK:- Double Null check Validation
    
    func nullConditionForFloat(floatValue : Any) -> Float {
        if let value = floatValue as? Float {
            return value
        }else{
            return 0
        }
    }
    
    // MARK:- Dictionary Null check Validation
    
    func nullConditionForDictionary(dict : Any) -> Dictionary<String, Any> {
        if let value = dict as? Dictionary<String, Any> {
            return value
        }else{
            return [:]
        }
    }
    
}
