//
//  RegisterViewController.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 26/09/19.
//  Copyright © 2019 Priyanka Bandaru. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var bgViews: [UIView]! {
        didSet {
            for vw in bgViews {
                setEffectsToVw(vw: vw)
            }
        }
    }
    
    @IBOutlet var textFields: [UITextField]! 
        
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createBtnAction(_ sender: UIButton) {
        self.isEditing = false
        guard let name = textFields[0].text, let email = textFields[1].text, let password = textFields[2].text, let confirmPassword = textFields[3].text, let mobile = textFields[4].text, !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !mobile.isEmpty else {
            let alert : UIAlertController = UIAlertController(title: "Register error", message: "Please fill All Details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if isValidEmail(testStr: email) {
            var obj = ParserStruct.structLoginAndRegister()
            obj.name = name
            obj.email = email
            obj.password = password
            obj.password_confirmation = confirmPassword
            obj.mobile = mobile
            obj.gender = segmentedControl.selectedSegmentIndex == 0 ? "Male" : "Female"
            ServerCallRegister(structObj: obj)
        }
        else {
            showToastWithMessage(message: "Please enter valid email")
        }
        
    }
    
    // Service Calls
    func ServerCallRegister(structObj: ParserStruct.structLoginAndRegister) {
        
        if !checkNet() {
            showToastWithMessage(message: no_Internet_Connection)
            return
        }
        
        let loader = showLoader(message: "Loading...")
        
        APIs.sharedInstance.Service_Call(withParameters: structObj, withMethodName: .Register, complitionHandler: {(_ response: Any, _ error: Error?, _ isSuccess: Bool) -> Void in
            
            DispatchQueue.main.async(execute: {() -> Void in
                hideLoader(loader: loader)
                
                let result : NSDictionary = nullConditionForDictionary(dict: response) as NSDictionary
                
                if isSuccess {
                    
                    if result.count > 0 {
                        showToastWithMessage(message: nullConditionForString(str: result.value(forKey: "message") as Any))
                        self.navigationController?.popViewController(animated: false)
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
