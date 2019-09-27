//
//  AppDefines.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 27/09/19.
//

import Foundation
import UIKit

let IPHONE_4_SCREEN_HEIGHT = 480
let IPHONE_4_SCREEN_WIDTH = 320

let IPHONE_5_SCREEN_HEIGHT = 568 //5S,SE
let IPHONE_6_SCREEN_HEIGHT = 667     //6S, 7
let IPHONE_6PLUS_SCREEN_HEIGHT  = 736 // 6s Plus, 7 Plus

let IPHONE_5_SCREEN_WIDTH  = 320 //5S,SE
let IPHONE_6_SCREEN_WIDTH = 375   //6S, 7
let IPHONE_6PLUS_SCREEN_WIDTH = 414 // 6s Plus, 7 Plus

let IPAD_SCREEN_WIDTH = 768 // iPad

let SYSTEM_VERSION = UIDevice.current.systemVersion

let THEME_COLOR = UIColor(red: 214 / 255, green: 174 / 255, blue: 42 / 255, alpha: 1)


let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT  = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH  = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
let SCREEN_MIN_LENGTH  = (min(SCREEN_WIDTH, SCREEN_HEIGHT))

let APP_DELEGATE  = UIApplication.shared.delegate as! AppDelegate
let storyBoardMain = UIStoryboard(name: "Main", bundle: Bundle.main)
let RESIGN_KEYBOARD = UIApplication.shared.keyWindow?.endEditing(true)

let X_ACCESS_TOKEN = "api_token"
let USER_NAME = "name"
let USER_EMAIL = "email"
let no_Internet_Connection = "No Internet Connection"

//MARK: - DISPATCH QUEUES -
//     DispatchQueue.main.async {}
//     DispatchQueue.main.async(execute: {() -> Void in        })

