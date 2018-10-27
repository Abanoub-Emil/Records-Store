//
//  FavoriteTableViewCell.swift
//  Grapes'n'berries
//
//  Created by Champion on 10/23/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    var recordId = 0
    var favoriteCellDelegate: FavoriteCellDelegate?
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var recordImage: UIImageView!
    
    @IBOutlet weak var artist: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func removeFromFavorite(_ sender: UIButton) {
        favoriteCellDelegate?.removeFromFavorite(id: recordId)
    }
    
}

protocol FavoriteCellDelegate : class {
    func removeFromFavorite(id: Int)
}
