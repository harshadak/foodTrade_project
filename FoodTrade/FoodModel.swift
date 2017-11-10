//
//  FoodModel.swift
//  FoodTrade
//
//  Created by Grant Brooks on 9/20/17.
//  Copyright © 2017 dly. All rights reserved.
//

class FoodModel{
    
    var id: String?
    var name: String?
    var foodImageURL: String?
    var category: String?
    var desc: String?
    var price:String?
    var chef: String?
    var chefID: String?
    var phoneNumber: String?
    var pickUpLocation: String?
    var pickUpLatitude: Double?
    var pickUpLongitude: Double?
//    var foodImage: Data?
    
    init(id: String?, name: String?, foodImageURL: String?, category: String?, desc: String?, price: String?, chef: String?, chefID: String?, phoneNumber: String?, pickUpLocation: String?, pickUpLatitude: Double?, pickUpLongitude: Double?) {
        self.id = id
        self.name = name
        self.foodImageURL = foodImageURL
        self.category = category
        self.desc = desc
        self.price = price
        self.chef = chef
        self.chefID = chefID
        self.phoneNumber = phoneNumber
        self.pickUpLocation = pickUpLocation
        self.pickUpLatitude = pickUpLatitude
        self.pickUpLongitude = pickUpLongitude
    }
}
