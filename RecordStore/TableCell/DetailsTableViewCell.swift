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
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
}

protocol DetailsCellDelegate : class {
    func recordAddedToBucket(num: Int)
}
