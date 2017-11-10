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
        //location stuff
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        

        
        refFoods = Database.database().reference()
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("locatoin---->",ourLocation)
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
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        let distanceInMiles = Int(distanceInMeters / 1609)
        let distanceString = String(distanceInMiles)
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
    }


    var imageURL: String?
    
    func addFood(by controller: UIViewController, newFood: [String : Any]) {
        navigationController?.popViewController(animated: true)
        
        print(newFood["foodImageURL"])

        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("food_images").child("\(imageName).png")
        
        let foodUpload = newFood["foodImageURL"]! as! UIImage
        
        if let uploadData = UIImagePNGRepresentation(foodUpload) {
            
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                print("metaprint",metadata!)
                if let error = error {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    print(profileImageUrl)
                    print(type(of: profileImageUrl))
                    self.imageURL = profileImageUrl
                    let key = self.refFoods.child("foods").childByAutoId().key
                    var newItem = newFood
                    newItem["id"] = key
                    newItem["foodImageURL"] = profileImageUrl
                    print("this is the good thinking", self.imageURL!)
                    
                    self.refFoods.child("foods").child(key).setValue(newItem)
                    
                }
                
            })
        }
        

    }
    // We build the food cat list HERE
    func buildFoodCatList() {
        for item in foodsList{
            if item.category == foodCatName {
                foodsCategoryList.append(item)
            }
        }
        tableView.reloadData()
    }
    
    // Gets our locatoin from Core Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        ourLocation = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        print("inside function location", ourLocation)
        
    }
    
    func deleteFood(by: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: by) {
            print("delete food button pressed this is the index path",indexPath.row)
            let deletedItem = foodsCategoryList[indexPath.row].id
            
            self.refFoods.child("foods").child(deletedItem!).removeValue()
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func messageChef(by: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: by) {
            let messageThisChef = foodsCategoryList[indexPath.row].phoneNumber
            let messageChefName = foodsCategoryList[indexPath.row].chef!
            let messageFoodPrice = foodsCategoryList[indexPath.row].price!
            let messageFoodPic = foodsCategoryList[indexPath.row].foodImageURL!
            let x = UIImage(messageFoodPic)
            
            if MFMessageComposeViewController.canSendText() {
                let composeVC = MFMessageComposeViewController()
                composeVC.messageComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.recipients = [messageThisChef!]
                composeVC.body = "Good Day \(messageChefName) \(messageChefName) \(messageFoodPrice) \(x)"
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
                
            } else {
                print("Cannot send text")
            }
        }
    }
    

    
}
