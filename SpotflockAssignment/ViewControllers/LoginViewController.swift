//
//  LoginViewController.swift
//  EasyHomeLoan
//
//  Created by Priyanka Bandaru on 07/09/19.
//  Copyright © 2019 Vinodh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var bgView: UIView!
    
    @IBOutlet var userNameTF: UITextField!{
        didSet{
            userNameTF.textColor = UIColor.white
        }
    }
    
    @IBOutlet var passwordTF: UITextField!{
        didSet{
            passwordTF.textColor = UIColor.white
        }
    }
    
    @IBOutlet var signInBtn: UIButton! {
        didSet {
            setEffectsToBtn(btn: signInBtn)
        }
    }
    
    @IBOutlet var registerBtn: UIButton!{
        didSet {
            setEffectsToBtn(btn: registerBtn)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       UISetup()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func UISetup() {
        let passImg = UIButton(type: .custom)
        passImg.setImage(UIImage(named: "password"), for: .normal)
        passImg.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passImg.frame = CGRect(x: CGFloat(passwordTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(35))
        passwordTF.leftView = passImg
        passwordTF.leftViewMode = .always
        
        let userImg = UIButton(type: .custom)
        userImg.setImage(UIImage(named: "user"), for: .normal)
        userImg.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        userImg.frame = CGRect(x: CGFloat(userNameTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(35))
        userNameTF.leftView = userImg
        userNameTF.leftViewMode = .always
        
        userNameTF.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signInBtnAction(_ sender: UIButton) {
        self.isEditing = false
        guard let username = userNameTF.text, let password = passwordTF.text, !username.isEmpty, !password.isEmpty else {
            let alert : UIAlertController = UIAlertController(title: "Login error", message: "Please enter Username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if isValidEmail(testStr: username) {
            var obj = ParserStruct.structLoginAndRegister()
            obj.email = username
            obj.password = password
            ServerCallLogin(structObj: obj)
        }
        else {
            showToastWithMessage(message: "Please enter valid email")
        }

    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
    }
    
    // Service Calls
    func ServerCallLogin(structObj: ParserStruct.structLoginAndRegister) {
        
        if !checkNet() {
            showToastWithMessage(message: no_Internet_Connection)
            return
        }
        
        let loader = showLoader(message: "Loading...")
        
        APIs.sharedInstance.Service_Call(withParameters: structObj, withMethodName: .Login, complitionHandler: {(_ response: Any, _ error: Error?, _ isSuccess: Bool) -> Void in
            
            DispatchQueue.main.async(execute: {() -> Void in
                hideLoader(loader: loader)
                
                let result : NSDictionary = nullConditionForDictionary(dict: response) as NSDictionary

                if isSuccess {
                    
                    let user : NSDictionary = nullConditionForDictionary(dict: result.value(forKey: "user") as Any) as NSDictionary
                    if user.count > 0 {
                        showToastWithMessage(message: nullConditionForString(str: result.value(forKey: "message") as Any))
                        APP_DELEGATE.setRootWindowWithIdentifier(identifier: "kStream")
                    }
                    else {
                        showToastWithMessage(message: "Something went wrong. Try again")
                    }
                }
                else {
                    showToastWithMessage(message: nullConditionForString(str: result.value(forKey: "message") as Any))
                }
            })
            
        })
    }
    
}
