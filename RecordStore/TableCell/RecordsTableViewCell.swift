//
//  RecordsTableViewCell.swift
//  Grapes'n'berries
//
//  Created by Champion on 10/22/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit
import SDWebImage

class RecordsTableViewCell: UITableViewCell {
    
    let defaults = UserDefaults.standard
    var cellRecord = Record()
    weak var recordCellDelegate: RecordCellDelegate?
    @IBOutlet weak var recordTitle: UILabel!
    
    @IBOutlet weak var recordArtist: UILabel!
    
    @IBOutlet weak var recordMainPrice: UILabel!
    
    @IBOutlet weak var recordSubPrice: UILabel!
    
    @IBOutlet weak var recordImage: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        
        recordCellDelegate?.didSelectRecord(cellRecord.id!)
        getFavoriteRecords()
    }
    
    
    @IBAction func goToRecordDetails(_ sender: UIButton) {
        recordCellDelegate?.presentDetailsView(record: cellRecord)
    }
    
    
    
    func getFavoriteRecords() {
//        let favoriteArray = defaults.array(forKey: "favoriteRecords")  as? [Int] ?? [Int]()
//        print(favoriteArray)
//        for id in favoriteArray {
//            if id == cellRecord.id {
//                print(id)
//                favoriteButton.setImage(UIImage(named: "red"), for: .normal)
//                return
//            }
//        }
//        favoriteButton.setImage(UIImage(named: "White"), for: .normal)
        
    }
    
    
    
}

protocol RecordCellDelegate : class {
    func didSelectRecord(_ id: Int)
    func presentDetailsView(record: Record)
}
