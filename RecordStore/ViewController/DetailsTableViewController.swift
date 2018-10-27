//
//  DetailsTableViewController.swift
//  Grapes'n'berries
//
//  Created by Champion on 10/23/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsTableViewController: UIViewController {
    
    
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    @IBOutlet weak var numberOfRecordsInBucket: UIButton!
    
    let defaults = UserDefaults.standard
    var myRecord = Record()
    var favoriteArray = [Int]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "detailsCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteArray = defaults.array(forKey: "favoriteRecords")  as? [Int] ?? [Int]()
        let bucketRecords = defaults.integer(forKey: "bucket")
        numberOfRecordsInBucket.setTitle(String(bucketRecords), for: .normal)
        if (myRecord.isFavorite) {
            isFavoriteButton.setImage(UIImage(named: "red"), for: .normal)
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
}


extension DetailsTableViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1100
    }
    
    
    
}

// MARK: - Table view data source

extension DetailsTableViewController: UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.detailsCellDelegate = self
        cell.recordDetails = myRecord
        
        if (myRecord.isFavorite){
            cell.favoriteButton.setImage(UIImage(named: "red"), for: .normal)
        }
        cell.title.text = myRecord.title
        cell.artist.text = myRecord.artist
        cell.label.text = myRecord.label
        cell.recordDescription.text = myRecord.description
        cell.releaseDate.text = String(myRecord.releaseDate!)
        let recordPrice = Utils.splitPrice(price: myRecord.price!)
        cell.mainPrice.text = String(recordPrice[0])
        cell.subPrice.text = String(recordPrice[1])
        cell.mainPrice2.text = String(recordPrice[0])
        cell.subPrice2.text = String(recordPrice[1])
        cell.recordImage.sd_setImage(with: URL(string: myRecord.image!), placeholderImage: UIImage(named: "record1"))
        
        
        return cell
    }
    
    
    
    
    
}

extension DetailsTableViewController: DetailsCellDelegate{
    
    func recordAddedToBucket(num: Int) {
        
        print("Added to bucket")
        var recordsInBucket = defaults.integer(forKey: "bucket")
        recordsInBucket = recordsInBucket + num
        defaults.set(recordsInBucket, forKey: "bucket")
        
        numberOfRecordsInBucket.setTitle(String(recordsInBucket), for: .normal)
        
    }
}


