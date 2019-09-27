//
//  APIs.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 27/09/19.
//

import UIKit


let SERVER_ERROR = 500
let INVALID_TOKEN = 498
let TOO_MANY_REQUESTS = 429
let LOGICAL_ERROR = 400
let RESPONSE_CONFLICT = 499

let SESSION_EXPIRED = 101
let ACCOUNT_NOTFOUND = 404


typealias ComplitionHandler = (_ response: Any, _ error: Error?, _ isSuccess: Bool) -> Void

class APIs: NSObject {
    
    // MARK: --- Shared Instatnce
    class var sharedInstance: APIs
    {
        struct  Static
        {
            static let instance : APIs = APIs()
        }
        return Static.instance
    }
    
    
    // MARK: --- Service_CallWithData
    func Service_Call(withParameters dicParameters : Any?,  withMethodName methodName:apiMethodName, complitionHandler : @escaping ComplitionHandler)
    {
        if(!checkNet())
        {
            complitionHandler("Please check your Internet connection.", nil, false);
            return;
        }
        
        let jsonData : Data? = convertRequest(withApiMethodName: methodName, withObject: dicParameters)
        
        var urlString = "\(BASE_URL)\(getURLforMethod(methodName, AppendParams: dicParameters as Any))" //"\(getapi_SpotflockAssignmentAttach(baseUrl: BASE_URL))\(getURLforMethod(methodName, AppendParams: dicParameters as Any))"
        
        urlString = urlString.replacingOccurrences(of: " ", with: "%20")
        
        let url = URL.init(string: urlString)!
        
        print("URL ===>> : Url :\(urlString)")
        
        var  request = NSMutableURLRequest.init(url: url)
        if jsonData != nil
        {
            request.httpBody = jsonData
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            request.addValue("\(String(describing: jsonString.count))", forHTTPHeaderField: "Content-Length")
            
             print("JSON Request ++++>>> : \(jsonString)")
        }
        request = getHeaders(methodName, with: request)
        request.timeoutInterval = 60
        print("Request method type: \(request.httpMethod)")

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let sessionTask : URLSessionTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let  httpResponse = response as? HTTPURLResponse
            
            if httpResponse == nil {
                complitionHandler("", error, false)
                return
            }
            
            
            if httpResponse?.statusCode == 500 || httpResponse?.statusCode == 404
            {
                complitionHandler("Error occured while connecting to server.", error, false)
                return
            }
            if httpResponse?.statusCode == 400 || httpResponse?.statusCode == 429
            {
                complitionHandler("Something went wrong", error, false)
                return
            }
            if (error != nil) || response == nil
            {
                complitionHandler("Error occured while connecting to server.", error, false)
            }
            else
            {
                let jsonResponse = String(data: data!, encoding: .utf8)
                print("Response : \(jsonResponse!)")
                
                if jsonResponse == "" {
                    complitionHandler("Invalid Credentials. Please try again...", error, false)
                }
                else  {
                    
                    let dicResponse : NSDictionary = nullConditionForDictionary(dict: (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as Any) as NSDictionary
                    
                    let statusCode =  httpResponse?.statusCode
       
                    if statusCode == SESSION_EXPIRED || statusCode == INVALID_TOKEN
                    {

                        complitionHandler("Your session has expired. Please login to continue...", error, false)
                        return
                    }
                    var bodyStatusCode = ""
                    if methodName == .Login {
                        bodyStatusCode = nullConditionForString(str: dicResponse .value(forKey: "status") as Any)
                    }
                    else {
                        bodyStatusCode = nullConditionForBool(boolValue: dicResponse .value(forKey: "success") as Any) ? "true" : "false"
                    }
                    
                    
                    if bodyStatusCode == "false" {
                        complitionHandler("Something went wrong", error, false)
                        return
                    }
                    
                    if bodyStatusCode == "true"{
                        
                        let userDict : NSDictionary  =   nullConditionForDictionary(dict: dicResponse .value(forKey: "user") as Any) as NSDictionary
                        let strToken : String = nullConditionForString(str: userDict .value(forKey: X_ACCESS_TOKEN) as Any)

                        
                        if strToken.count > 0 {
                            DispatchQueue.main.async(execute: {() -> Void in
                                setUserDefaults(with: String(format: "Bearer %@", strToken), key: X_ACCESS_TOKEN)
                                setUserDefaults(with: nullConditionForString(str: userDict .value(forKey: USER_NAME) as Any), key: USER_NAME)
                                setUserDefaults(with: nullConditionForString(str: userDict .value(forKey: USER_EMAIL) as Any), key: USER_EMAIL)
                            })
                        }
                        
                      complitionHandler(dicResponse, error, true)
                    }
                    else {
                        complitionHandler(dicResponse, error, false)
//                        showToastWithMessage(message: "Something went wrong")
                    }
                  
                }
            }
            
            dispatchGroup.leave()
        }
        sessionTask.resume()
    }
    
    
    
    // MARK: --- Convert Request
    func convertRequest(withApiMethodName methodName:apiMethodName, withObject object:Any?) -> Data?
    {
        let objJsonConverter = JsonConverter.sharedInstance
        switch methodName
        {
        case .Register:
            return objJsonConverter.convertRegisterObject(toJson: object as! ParserStruct.structLoginAndRegister)
            
        case .Login:
            return objJsonConverter.convertLoginObject(toJson: object as! ParserStruct.structLoginAndRegister)
            
        case .DashboardFeed:
            return nil
            
//        default:
//            return nil
   
        }
        
    }
    
    
    // MARK: --- get URL for Method
    func getURLforMethod(_ MethodName: apiMethodName, AppendParams: Any ) -> String
    {
        
        var url: String
        switch MethodName
        {
        case .Register:
            url = "register"
            
        case .Login:
            url = "login"
            
        case .DashboardFeed:
            url = "kstream"
        
        }
        
        return url
    }
    
    
    // MARK: --- Header methods
    func getHeaders(_ methodName: apiMethodName, with request: NSMutableURLRequest) -> NSMutableURLRequest
    {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if nullConditionForString(str: getUserDefaults(with: X_ACCESS_TOKEN)).count > 8 {
            request.addValue(getUserDefaults(with: X_ACCESS_TOKEN) as! String, forHTTPHeaderField: "Authorization")
            print("AUTH TOKEN ++++++>>>", getUserDefaults(with: X_ACCESS_TOKEN) as! String)
        }
        
        switch methodName
        {
        case .DashboardFeed:
            request.httpMethod = "GET"
            
        case .Register,
             .Login:
            request.httpMethod = "POST"

        }
        return request
    }
 
    
}
