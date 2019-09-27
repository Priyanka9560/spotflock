//
//  AppHelpers.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 27/09/19.
//

import Foundation
import UIKit


class AppHelpers: NSObject {
    
    /* Image downloding common Server call*/
    
    class func downloadImage(with url: URL, completionBlock: @escaping (_ succeeded: Bool, _ image: UIImage?, _ error: Error?, _ data: Data) -> Void) {

        let request = NSMutableURLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: {(_ response: URLResponse?, _ data: Data?, _ error: Error?) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                if image == nil {
                    if data == nil {
                        return
                    }
                    completionBlock(true, nil, error, data!)
                }
                else{
                    completionBlock(true, image!, error, data!)
                }
            }
            else {
                if data == nil {
                    return
                }
                completionBlock(false, nil, error, data!)
            }
        } )
    }
    
    class func dataStoreToFilePath(with data:Data , fileName str:String){
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        //        let DocumentDirURL =  URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = DocumentDirURL.appendingPathComponent(str)
        
        do {
            // Write to the file
            try data.write(to: fileURL, options: .atomic)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
        
    }
}

/* Network Checking */

extension NSObject
{
    func checkNet() -> Bool
    {
        let reachability = Reachability()
        let status = reachability?.connection
        print("Connection status:",status! )
        switch status{
        case .wifi?:
            print("Reachable via WiFi")
            return true
        case .cellular?:
            print("Reachable via Cellular")
            return true
        case .none:
            print("Network not reachable")
            return false
        case .some(.none):
            print("Network not reachable")
            return false
        }
    }
    func safeObjectForKey(key : String) -> Any?
    {
        if self.value(forKey: key) is NSNull
        {
            return nil
        }
        else
        {
            return self.value(forKey: key)
        }
    }
}


/* Font Setting */
func setRandomFont(withSize size : CGFloat, withFontName fontName: String) -> UIFont
{
    var font : UIFont!
    if SCREEN_HEIGHT ==  CGFloat(IPHONE_4_SCREEN_HEIGHT)
    {
        font = UIFont(name: fontName, size: size)!
    }
    else if (SCREEN_HEIGHT == CGFloat(IPHONE_5_SCREEN_HEIGHT)) // iPhone 5,5S, SE
    {
        font = UIFont(name: fontName, size: size+1)!
    }
    else if (SCREEN_WIDTH == CGFloat(IPHONE_6_SCREEN_WIDTH)) // iPhone 6, 6S, 7, Xs
    {
        font = UIFont(name: fontName, size: size+2)!
    }
    else if (SCREEN_WIDTH == CGFloat(IPHONE_6PLUS_SCREEN_WIDTH)) // iPhone 6 Plus, 6s Plus, 7 Plus, 8 Plus XR, Xs Max
    {
        font = UIFont(name: fontName, size: size+4)!
    }
    else if (SCREEN_WIDTH == CGFloat(768)) // iPad
    {
        font = UIFont(name: fontName, size: size+5)!
    }
    else
    {
        font = UIFont(name: fontName, size: size+4)!
    }
    return font
}



/* Loader Spinner Setting */

func showLoader(message : String) -> SampleView {
    
    let spinnerview = SpinnerCustomView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    //spinnerview.layer.cornerRadius = 15.0f;
    // spinnerview.layer.masksToBounds = YES;
    spinnerview.titleLabel.text = message
    spinnerview.backgroundColor = UIColor.clear
    let spinner = SampleView.popup(withContentView: spinnerview)
    
    spinner?.backgroundColor = UIColor.clear
    spinner?.shouldDismissOnBackgroundTouch = false
    spinner?.show()
    
    return spinner!
}

func hideLoader(loader : SampleView) {
    loader.removeFromSuperview()
    loader.dismiss(true)
}


//MARK:- Button Borderline

func setBorderToView(view:UIView, borderColor:UIColor) {
    
    view.backgroundColor = .clear
    view.layer.cornerRadius = 22
    view.layer.borderWidth = 1
    view.layer.masksToBounds = true
    view.layer.borderColor = borderColor.cgColor
}

func setBorderLineToView(view:UIView, borderColor:UIColor) {
    
    view.backgroundColor = .clear
    view.layer.cornerRadius = 4
    view.layer.borderWidth = 1
    view.layer.masksToBounds = true
    view.layer.borderColor = borderColor.cgColor
}

func setEffectsToBtn(btn : UIButton) {
    btn.layer.masksToBounds = false
    btn.layer.shadowColor = THEME_COLOR.cgColor
    btn.layer.shadowOpacity = 0.4
    btn.layer.shadowRadius = 4
    btn.layer.shadowOffset = .zero
}

func setEffectsToVw(vw : UIView) {
    vw.layer.masksToBounds = false
    vw.backgroundColor = UIColor.clear
    vw.layer.borderWidth = 0.5
    vw.layer.cornerRadius = 10
    vw.layer.borderColor = THEME_COLOR.cgColor
    vw.layer.shadowColor = THEME_COLOR.cgColor
    vw.layer.shadowOpacity = 0.4
    vw.layer.shadowRadius = 4
    vw.layer.shadowOffset = .zero
}

// MARK:- UserDefaults Handle

func setUserDefaults(with value: Any, key:String) {
    UserDefaults.standard.set(value , forKey :key)
    UserDefaults.standard.synchronize()
}

func getUserDefaults(with key:String) -> Any {
    return UserDefaults.standard.value(forKey: key) ?? ""
}

func clearUserDefaults() {
   let domain = Bundle.main.bundleIdentifier!
   let defaults = UserDefaults.standard
   defaults.removePersistentDomain(forName:domain)
   defaults.synchronize()
}

// MARK:- Show Toast

func showToastWithMessage(message : String){
//    let font: UIFont = setRandomFont(withSize: 15.0, withFontName: FONT_RAJDHANI_MEDIUM)
//    KSToastView.ks_setAppearanceTextFont(font)
    KSToastView.ks_showToast(message, duration: 5.0)
}

// MARK:- Email RegEx

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
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

// MARK:- Float Null check Validation

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

// MARK:- Data Null check Validation

func nullConditionForData(data : Any) -> Data {
    if let value = data as? Data {
        return value
    }else{
        return Data()
    }
}
