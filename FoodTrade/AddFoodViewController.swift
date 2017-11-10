//
//  AddFoodViewController.swift
//  FoodTrade
//
//  Created by Grant Brooks on 9/25/17.
//  Copyright © 2017 dly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class AddFoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MapViewDelegate {

    weak var delegate: AddFoodDelegate?
    var callingSegue: String?
    var index: IndexPath?
    var catName = String()
    var latitude = Double()
    var longitude = Double()
    var chefIdent: String = (Auth.auth().currentUser?.uid)!
    var editFoodItem: FoodModel?
    var uniqueId: String = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var chefTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pickUpLocationTextField: UITextField!
    
    
    @IBOutlet weak var foodImage: UIImageView!
    var foodImg: UIImage?
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text != "" && phoneTextField.text != "" && chefTextField.text != "" {
            let food = ["id": uniqueId as String,
                        "name": nameTextField.text! as String,
                        "foodImageURL": foodImage.image!,
                        "category": categoryTextField.text! as String,
                        "desc": descriptionTextField.text! as String,
                        "price": priceTextField.text! as String,
                        "chef": chefTextField.text! as String,
                        "chefID": chefIdent as String,
                        "phoneNumber": phoneTextField.text! as String,
                        "pickUpLocation": pickUpLocationTextField.text! as String,
                        "pickUpLatitude": latitude as Double,
                        "pickUpLongitude": longitude as Double
                ] as [String : Any]
            delegate?.addFood(by: self, newFood: food, indexPath: index)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        
        if let selectedImage = selectedImageFromPicker {
            foodImage.image = selectedImage
            foodImg = selectedImage
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectPhotoFromCamera(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func selectPhotoFromLibrary(_ sender: UIButton) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
//    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
//        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
//        let imagePickerController = UIImagePickerController()
//        // Only allow photos to be picked, not taken.
//        imagePickerController.sourceType = .photoLibrary
//        // Make sure ViewController is notified when the user picks an image.
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//        present(imagePickerController, animated: true, completion: nil)
//    }
    
    @IBAction func locationTextPressed(_ sender: UITextField) {
        print("tap tap tap 2")
        performSegue(withIdentifier: "toMapSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navvc = segue.destination as! UINavigationController
        let mapvc = navvc.topViewController as! MapViewController
        mapvc.delegate = self
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.backgroundColor = UIColor.clear
        
        if callingSegue == "editFoodSegue" {
            self.title = "Edit Food"
            uniqueId = (editFoodItem?.id)!
            categoryTextField.text = editFoodItem?.category
            nameTextField.text = editFoodItem?.name
            descriptionTextField.text = editFoodItem?.desc
            priceTextField.text = editFoodItem?.price
            chefTextField.text = editFoodItem?.chef
            phoneTextField.text = editFoodItem?.phoneNumber
            pickUpLocationTextField.text = editFoodItem?.pickUpLocation
            latitude = (editFoodItem?.pickUpLatitude)!
            longitude = (editFoodItem?.pickUpLongitude)!
            
            //VERY PATIENT TO GET YOUR PIC KEEP WAITING
            let url = URL(string: (editFoodItem?.foodImageURL)!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                //download hit an error so lets return out
                if let error = error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!) {
                        self.foodImage.image = downloadedImage
                    }
                })
            }).resume()
            
        } else {
            self.title = "Create Food"
            categoryTextField.text = catName
            foodImage.image = #imageLiteral(resourceName: "salad")
            nameTextField.text = ""
            descriptionTextField.text = ""
            priceTextField.text = ""
            chefTextField.text = ""
            phoneTextField.text = ""
            pickUpLocationTextField.text = ""
            latitude = 0.0
            longitude = 0.0
        }
        
        //money stuff
        priceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)


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
    
    func addCoordinates(by controller: UIViewController, latitude: Double, longitude: Double, locationName: String) {
        print("delegate lat long", latitude, longitude, locationName)
        dismiss(animated: true, completion: nil)
        pickUpLocationTextField.text = locationName
        self.latitude = latitude
        self.longitude = longitude
        
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    ///// money stuff
    func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
