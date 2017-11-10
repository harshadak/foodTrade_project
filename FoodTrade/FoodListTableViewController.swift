//
//  FoodInfoViewController.swift
//  FoodTrade
//
//  Created by dly on 9/19/17.
//  Copyright © 2017 dly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
import MessageUI

class FoodListTableViewController: UITableViewController, AddFoodDelegate, CLLocationManagerDelegate, deleteFoodDelegate, MFMessageComposeViewControllerDelegate, messageChefDelegate {
    
    // Gets our locatoin from Core Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        ourLocation = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
/////DO NOT FORGET TO DO THIS or table data won't show accurate location data, very important!!!/////
        tableView.reloadData()
        print("inside function location", ourLocation)
    }
    
    // Firebase
    var refFoods: DatabaseReference!
    var handle: DatabaseHandle?
    
    // Location stuff
    var manager = CLLocationManager()
    var location = CLLocation()
    var ourLocation = CLLocation()
    
    
    
    var foodsList = [FoodModel]()
    var foodCategory = UIButton()
    var foodCatName = String()
    var foodsCategoryList = [FoodModel]()
    
    //Messaging stuff
    var recipient1: [String] = []



    
    override func viewDidLoad() {
        super.viewDidLoad()

//        //location stuff
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//        
//        refFoods = Database.database().reference()
//        print("locatoin dddiddd loadddddddd---->",ourLocation)
////                refFoods.observe(DataEventType.value, with:{(snapshot) in
//        handle = refFoods.child("foods").observe(DataEventType.value, with:{(snapshot) in
//            if snapshot.childrenCount > 0{
//                print("before remove", self.foodsList)
//                self.foodsList.removeAll()
//                self.foodsCategoryList.removeAll()
//                print("after remove", self.foodsList)
//                
//                for foods in snapshot.children.allObjects as![DataSnapshot]{
//                    let foodObject = foods.value as? [String: AnyObject]
//                    
//                    let id = foodObject?["id"]
//                    let name = foodObject?["name"]
//                    let foodImageURL = foodObject?["foodImageURL"]
//                    let category = foodObject?["category"]
//                    let desc = foodObject?["desc"]
//                    let price = foodObject?["price"]
//                    let chef = foodObject?["chef"]
//                    let chefID = foodObject?["chefID"]
//                    let phoneNumber = foodObject?["phoneNumber"]
//                    let pickUpLocation = foodObject?["pickUpLocation"]
//                    let pickUpLatitude = foodObject?["pickUpLatitude"]
//                    let pickUpLongitude = foodObject?["pickUpLongitude"]
//                    
//                    let foodItem = FoodModel(id: id as! String?, name: name as! String?, foodImageURL: foodImageURL as! String?, category: category as! String?, desc: desc as! String?, price: price as! String?, chef: chef as! String?, chefID: chefID as! String?, phoneNumber: phoneNumber as! String?, pickUpLocation: pickUpLocation as! String?, pickUpLatitude: pickUpLatitude as! Double?, pickUpLongitude: pickUpLongitude as! Double?)
//                    
//                    self.foodsList.append(foodItem)
//                }
//                print("adding new ones")
//                self.buildFoodCatList()
//            }
//        })
//// HANDLER ENDS
//        
//        //category stuff
//        
//        if foodCategory.tag == 0 {
//            foodCatName = "Appetizer"
//        }
//        else if foodCategory.tag == 1 {
//            foodCatName = "Salad"
//        }
//        else if foodCategory.tag == 2 {
//            foodCatName = "Entree"
//        }
//        else {
//            foodCatName = "Desserts"
//        }
//        self.title = foodCatName
//        
//        
//        tableView.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("locatoin wil apppppppppppppeparaerearer---->",ourLocation)
        //location stuff
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        refFoods = Database.database().reference()
        print("locatoin dddiddd loadddddddd---->",ourLocation)
        //                refFoods.observe(DataEventType.value, with:{(snapshot) in
        handle = refFoods.child("foods").observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount > 0{
                print("before remove", self.foodsList)
                self.foodsList.removeAll()
                self.foodsCategoryList.removeAll()
                print("after remove", self.foodsList)
                
                for foods in snapshot.children.allObjects as![DataSnapshot]{
                    let foodObject = foods.value as? [String: AnyObject]
                    
                    let id = foodObject?["id"]
                    let name = foodObject?["name"]
                    let foodImageURL = foodObject?["foodImageURL"]
                    let category = foodObject?["category"]
                    let desc = foodObject?["desc"]
                    let price = foodObject?["price"]
                    let chef = foodObject?["chef"]
                    let chefID = foodObject?["chefID"]
                    let phoneNumber = foodObject?["phoneNumber"]
                    let pickUpLocation = foodObject?["pickUpLocation"]
                    let pickUpLatitude = foodObject?["pickUpLatitude"]
                    let pickUpLongitude = foodObject?["pickUpLongitude"]
                    
                    let foodItem = FoodModel(id: id as! String?, name: name as! String?, foodImageURL: foodImageURL as! String?, category: category as! String?, desc: desc as! String?, price: price as! String?, chef: chef as! String?, chefID: chefID as! String?, phoneNumber: phoneNumber as! String?, pickUpLocation: pickUpLocation as! String?, pickUpLatitude: pickUpLatitude as! Double?, pickUpLongitude: pickUpLongitude as! Double?)
                    
                    self.foodsList.append(foodItem)
                }
                print("adding new ones")
                self.buildFoodCatList()
            }
        })
        // HANDLER ENDS
        
        //category stuff
        
        if foodCategory.tag == 0 {
            foodCatName = "Appetizer"
        }
        else if foodCategory.tag == 1 {
            foodCatName = "Salad"
        }
        else if foodCategory.tag == 2 {
            foodCatName = "Entree"
        }
        else {
            foodCatName = "Desserts"
        }
        self.title = foodCatName
        
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Build rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodsCategoryList.count
    }
    
    //Build each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodListTableViewCell
        
        let foodItem: FoodModel

        foodItem = foodsCategoryList[indexPath.row]
        cell.delegate = self
        cell.messageDelegate = self
        cell.nameLabel.text = foodItem.name
        cell.descLabel.text = foodItem.desc
        cell.chefLabel.text = foodItem.chef
        cell.priceLabel.text = foodItem.price
        
        if let profileImageUrl = foodItem.foodImageURL {
            cell.imageLabel.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        //locaton stuff for cells
        let coordinate₀ = CLLocation(latitude: foodItem.pickUpLatitude!, longitude: foodItem.pickUpLongitude!)
        let coordinate₁ = ourLocation
        print("coordinate 1----------->", coordinate₁)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        let distanceInMiles = Double(distanceInMeters / 1609)
        
        let y = Double(round(100*distanceInMiles)/100)
        
        let distanceString = String(y)
        print("distance:  \(distanceInMiles)")
        //        print("distance\(ourLocation)")
        print("coordinates:",coordinate₀,coordinate₁)
        
        
        cell.distanceLabel.text = "\(distanceString) miles"
        
        //Add Delete button
        print("chefid --->>>>>",foodItem.chefID,Auth.auth().currentUser?.uid)
        if foodItem.chefID != Auth.auth().currentUser?.uid {
            cell.deleteFoodButton.isHidden = true
        } else {
            cell.deleteFoodButton.isHidden = false
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cvc = segue.destination as! AddFoodViewController
        cvc.catName = foodCatName
        cvc.delegate = self
        
        if segue.identifier == "editFoodSegue"{
            cvc.callingSegue = segue.identifier
            let index = sender as! IndexPath
            cvc.index = index
            cvc.editFoodItem = foodsCategoryList[index.row]
        }
    }


    var imageURL: String?
    
    func addFood(by controller: UIViewController, newFood: [String : Any], indexPath: IndexPath?) {
        navigationController?.popViewController(animated: true)
        
        //UPDATE food item
        if let ip = indexPath{
            //getting UIImage from add food page ready to upload
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("food_images").child("\(imageName).png")
            let foodUpload = newFood["foodImageURL"]! as! UIImage
            if let uploadData = UIImagePNGRepresentation(foodUpload) {
                //uploading data representation of Image
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    print("metaprint",metadata!)
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        self.imageURL = profileImageUrl
                        
                        //saving to Firebase Starts here
                        var newItem = newFood

                        newItem["foodImageURL"] = profileImageUrl
                        
                        self.refFoods.child("foods").child(newFood["id"] as! String).updateChildValues(newItem)
                    }
                })
            }
        }
        //ADD new food item
        else {
            //getting UIImage from add food page ready to upload
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("food_images").child("\(imageName).png")
            let foodUpload = newFood["foodImageURL"]! as! UIImage
            if let uploadData = UIImagePNGRepresentation(foodUpload) {
                //uploading data representation of Image
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    print("metaprint",metadata!)
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        self.imageURL = profileImageUrl
                        
                        //saving to Firebase Starts here
                        let key = self.refFoods.child("foods").childByAutoId().key
                        var newItem = newFood
                        newItem["id"] = key
                        newItem["foodImageURL"] = profileImageUrl
                        
                        self.refFoods.child("foods").child(key).setValue(newItem)
                    }
                })
            }
        }
    }
    // We build the food cat list HERE
    func buildFoodCatList() {
        
        let when = DispatchTime.now() + 0.1 // change to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
//            // Your code with delay
        
            for item in self.foodsList{


                //get distance for each item
                let coordinate₀ = CLLocation(latitude: item.pickUpLatitude!, longitude: item.pickUpLongitude!)
                let coordinate₁ = self.ourLocation
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
                let distanceInMiles = Double(distanceInMeters / 1609)
                
                let distanceFromYou = Double(round(100*distanceInMiles)/100)
                
                print("these are chef id and auth id",item.chefID, Auth.auth().currentUser?.uid)
                if item.category == self.foodCatName && distanceFromYou < 6 && item.chefID != Auth.auth().currentUser?.uid {
                    self.foodsCategoryList.append(item)
                }
                else if item.category == self.foodCatName && item.chefID == Auth.auth().currentUser?.uid {
                    self.foodsCategoryList.append(item)
                }
                print("length of food cat list------>",self.foodsCategoryList.count)
            }
        }
        tableView.reloadData()
    }
    
    // Delete Food stuff
    func deleteFood(by: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: by) {
        
            let alert = UIAlertController(title: self.foodsCategoryList[indexPath.row].name,
                                          message: "Are you sure you want to modify this food it looks delicious?",
                                          preferredStyle: .alert)
            
            let editAction = UIAlertAction(title: "Edit", style: .default)
            {
                _ in
                self.performSegue(withIdentifier: "editFoodSegue", sender: indexPath)

            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default)
            {
                _ in
                print("delete food button pressed this is the index path",indexPath.row)
                let deletedItem = self.foodsCategoryList[indexPath.row].id
                
                self.refFoods.child("foods").child(deletedItem!).removeValue()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
        
//        if let indexPath = tableView.indexPath(for: by) {
//            
//            let alert = UIAlertController(title: "New Entry",
//                                          message: "Add a new food category",
//                                          preferredStyle: .actionSheet)
//            
//            alert.addTextField(configurationHandler: nil)
//            
//            _ = UIAlertAction(title: "Modify", style: .default)
//            {
//                _ in
//                //            let textField = alert.textFields![0]
//                //            let newCategoryEntry = Category(context: self.managedObjectContext)
//                //            newCategoryEntry.name = textField.text!
////                self.saveCategoryEntries()
//            }
//            _ = UIAlertAction(title: "Delete", style: .default)
//            {
//                _ in
//                print("delete food button pressed this is the index path",indexPath.row)
//                let deletedItem = self.foodsCategoryList[indexPath.row].id
//                
//                self.refFoods.child("foods").child(deletedItem!).removeValue()
//            }
//            
//            _ = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            //        alert.addAction(saveAction)
//            //        alert.addAction(cancelAction)
//            present(alert, animated: true, completion: nil)
//        }
    }
    
    // Text Messaging Stuff
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }

    var foodPic: UIImage = #imageLiteral(resourceName: "salad")
    func messageChef(by: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: by) {
            let messageThisChef = foodsCategoryList[indexPath.row].phoneNumber
            let messageChefName = foodsCategoryList[indexPath.row].chef!
            let messageFoodName = foodsCategoryList[indexPath.row].name!
            let messageFoodDesc = foodsCategoryList[indexPath.row].desc!
            let messageFoodPrice = foodsCategoryList[indexPath.row].price!
            let messageFoodPicURL = foodsCategoryList[indexPath.row].foodImageURL!
            
            
            //otherwise fire off a new download
            let url = URL(string: messageFoodPicURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                //download hit an error so lets return out
                if let error = error {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!) {
                        self.foodPic = downloadedImage
                    }
                })
                
                if MFMessageComposeViewController.canSendText() {
                    let composeVC = MFMessageComposeViewController()
                    composeVC.messageComposeDelegate = self
                    
                    // Configure the fields of the interface.
                    composeVC.recipients = [messageThisChef!]
                    composeVC.body = "Hi Chef \(messageChefName)! I'm interested in purchasing your \(messageFoodName) for \(messageFoodPrice) each. Please reply YES to accept order and follow up with pick-up details."
                    
                    let data = UIImagePNGRepresentation(self.foodPic)

                    composeVC.addAttachmentData(data!, typeIdentifier: "image/png", filename: "foodtradepic.png")

                    // Present the view controller modally.
                    self.present(composeVC, animated: true, completion: nil)
                    
                } else {
                    print("Cannot send text")
                }

            }).resume()
        }
    }
    
    // Can be called many times to off screen
    // Remove observers on the ref to conserve memory
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refFoods.removeAllObservers()
    }
    
}
