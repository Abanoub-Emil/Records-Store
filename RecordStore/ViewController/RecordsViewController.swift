//
//  ViewController.swift
//  Grapes'n'berries
//
//  Created by Champion on 10/21/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class RecordsViewController: UIViewController, RecordCellDelegate {
    
    let defaults = UserDefaults.standard
    var allRecords = [Record]()
    var favoriteArray = [Int]()
    let recordsURL = "https://recordstor.herokuapp.com/api/recordstore/all"
    
    @IBOutlet weak var numberOfRecordsInBucket: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "RecordsTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        
        requestData()
    }
    
    func requestData(){
        
        AFWrapper.requestGETURL(recordsURL, success: { (json) in
            let records = JSON(json).arrayValue
            for record in records {
                let myRecord = Record()
                
                myRecord.id = record["id"].intValue
                if self.favoriteArray.contains(myRecord.id!){
                    myRecord.isFavorite = true
                }
                myRecord.title = record["title"].stringValue
                myRecord.artist = record["artist"].stringValue
                myRecord.image = record["image"].stringValue
                myRecord.price = record["price"].doubleValue
                myRecord.label = record["label"].stringValue
                myRecord.releaseDate = record["releaseDate"].intValue
                myRecord.description = record["descripton"].stringValue
                
                self.allRecords.append(myRecord)
            }
            
            self.tableView.reloadData()
        }) { (Error) in
            print(Error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteArray = defaults.array(forKey: "favoriteRecords")  as? [Int] ?? [Int]()
        let bucketRecords = defaults.integer(forKey: "bucket")
        numberOfRecordsInBucket.setTitle(String(bucketRecords), for: .normal)
    }
    
    @IBAction func goToFavorites(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "FavoriteStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        vc.allRecords = allRecords
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func sortNameDown(_ sender: UIButton) {
    }
    
    @IBAction func sortNameUp(_ sender: UIButton) {
    }
    
    @IBAction func sortPriceDown(_ sender: UIButton) {
    }
    
    @IBAction func sortPriceUp(_ sender: UIButton) {
    }
    
    @IBAction func sortDateDown(_ sender: UIButton) {
    }
    
    @IBAction func sortDateUp(_ sender: UIButton) {
    }
    
    
    
}

// MARK: - Table view data source

extension RecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RecordsTableViewCell
        cell.recordCellDelegate = self
        
        cell.cellRecord = allRecords[indexPath.row]
        cell.recordTitle.text = allRecords[indexPath.row].title
        cell.recordArtist.text = allRecords[indexPath.row].artist
        cell.recordImage.sd_setImage(with: URL(string: allRecords[indexPath.row].image!), placeholderImage: UIImage(named: "record1"))

        let recordPrice = Utils.splitPrice(price: allRecords[indexPath.row].price!)
        cell.recordMainPrice.text = String(recordPrice[0])
        cell.recordSubPrice.text = String(recordPrice[1])
        

        
        
        return cell
    }
    
    func didSelectRecord(_ id: Int) {
        
        for index in 0..<favoriteArray.count {
            if id == favoriteArray[index] {
                favoriteArray.remove(at: index)
                defaults.set(favoriteArray, forKey: "favoriteRecords")
                return
            }
        }
        favoriteArray.append(id)
        defaults.set(favoriteArray, forKey: "favoriteRecords")
        print(favoriteArray)
    }
    

}

extension RecordsViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetailsView(record: allRecords[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func presentDetailsView(record: Record) {
        let storyboard = UIStoryboard(name: "DetailsStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsTableViewController") as! DetailsTableViewController
        vc.myRecord = record
        present(vc, animated: true, completion: nil)
    }
    
}
