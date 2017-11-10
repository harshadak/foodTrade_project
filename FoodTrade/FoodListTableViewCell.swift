//
//  FoodListTableViewCell.swift
//  FoodTrade
//
//  Created by Grant Brooks on 9/20/17.
//  Copyright © 2017 dly. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {

    weak var delegate: deleteFoodDelegate?
    weak var messageDelegate: messageChefDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var chefLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    
    @IBAction func orderFoodPressed(_ sender: UIButton) {
        messageDelegate?.messageChef(by: self)
    }
    

    
    @IBOutlet weak var deleteFoodButton: UIButton!
    @IBAction func deleteFoodButtonPressed(_ sender: UIButton) {
        delegate?.deleteFood (by: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
