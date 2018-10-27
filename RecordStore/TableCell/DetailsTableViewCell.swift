//
//  DetailsTableViewCell.swift
//  Grapes'n'berries
//
//  Created by Champion on 10/23/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    var recordDetails = Record()
    let defaults = UserDefaults.standard
    weak var detailsCellDelegate: DetailsCellDelegate?
    var requestedQuantity = 1
    
    @IBOutlet weak var quantityLabel1: UILabel!
    
    @IBOutlet weak var quantityLabel2: UILabel!
    
    @IBOutlet weak var recordImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var mainPrice: UILabel!
    
    @IBOutlet weak var subPrice: UILabel!
    
    @IBOutlet weak var mainPrice2: UILabel!
    
    @IBOutlet weak var subPrice2: UILabel!
    
    @IBOutlet weak var recordDescription: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
    
    
    
    @IBAction func addToBucket(_ sender: UIButton) {
        print(requestedQuantity)
        detailsCellDelegate?.recordAddedToBucket(num: requestedQuantity)
    }
    
    @IBAction func decreaseRequestedQuantity(_ sender: UIButton) {
        if (requestedQuantity > 1){
            requestedQuantity = requestedQuantity - 1
            quantityLabel1.text = String(requestedQuantity)
            quantityLabel2.text = String(requestedQuantity)
            updatePrice()
        }
        
    }
    
    @IBAction func increaseRequestedQuantity(_ sender: UIButton) {
        requestedQuantity = requestedQuantity + 1
        quantityLabel1.text = String(requestedQuantity)
        quantityLabel2.text = String(requestedQuantity)
        updatePrice()
    }
    
    
    func updatePrice() {
        let recordPrice = Utils.splitPrice(price: Double(requestedQuantity) * recordDetails.price!)
        mainPrice.text = String(recordPrice[0])
        mainPrice2.text = String(recordPrice[0])
        subPrice.text = String(recordPrice[1])
        subPrice2.text = String(recordPrice[1])
        
    }
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        var favoriteArray = defaults.array(forKey: "favoriteRecords")  as? [Int] ?? [Int]()
        if recordDetails.isFavorite {
            recordDetails.isFavorite = false
            favoriteButton.setImage(UIImage(named: "White"), for: .normal)
            for index in 0..<favoriteArray.count {
                if recordDetails.id == favoriteArray[index] {
                    favoriteArray.remove(at: index)
                    break
                }
            }
            defaults.set(favoriteArray, forKey: "favoriteRecords")
            
        } else {
            recordDetails.isFavorite = true
            favoriteButton.setImage(UIImage(named: "red"), for: .normal)
            favoriteArray.append(recordDetails.id!)
            defaults.set(favoriteArray, forKey: "favoriteRecords")
            
        }
    }
    
}

protocol DetailsCellDelegate : class {
    func recordAddedToBucket(num: Int)
}
