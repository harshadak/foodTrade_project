//
//  LogInRegViewController.swift
//  FoodTrade
//
//  Created by Grant Brooks on 9/26/17.
//  Copyright © 2017 dly. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class LogInRegViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var fullnameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    
    @IBAction func logRegSegmentPressed(_ sender: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 1 {
            actionButton.setTitle("Register", for: .normal)
            fullnameText.isHidden = false
            addressText.isHidden = false
            phoneText.isHidden = false
        }
        else {
            actionButton.setTitle("Login", for: .normal)
            fullnameText.isHidden = true
            addressText.isHidden = true
            phoneText.isHidden = true
        }
    }
    
    @IBOutlet weak var actionButton: UIButton!
    

    @IBAction func action(_ sender: UIButton) {
        
        if emailText.text != "" && passwordText.text != "" {
            if segmentControl.selectedSegmentIndex == 0 {
                //login user
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        // sign in successful
                        self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                    }
                    else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        }
                        else {
                            print("ERROR")
                        }
                    }
                })
            }
            else {
                //sign up user
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                    }
                    else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        }
                        else {
                            print("ERROR")
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.layer.cornerRadius = 5
        segmentControl.selectedSegmentIndex = 0
        actionButton.setTitle("Login", for: .normal)
        fullnameText.isHidden = true
        addressText.isHidden = true
        phoneText.isHidden = true

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
