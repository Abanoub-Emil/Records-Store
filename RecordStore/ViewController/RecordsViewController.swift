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
    
    @IBOutlet var sortingButtons: [UIButton]!
        
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
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
            self.allRecords = Utils.sortByPriceDown(records: self.allRecords)
            self.tableView.reloadData()
            self.loadingIndicator.isHidden = true
        }) { (Error) in
            print(Error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteArray = defaults.array(forKey: "favoriteRecords")  as? [Int] ?? [Int]()
        if allRecords.count > 0 {
            for record in allRecords {
                if favoriteArray.contains(record.id!){
                    record.isFavorite = true
                } else {
                    record.isFavorite = false
                }
            }
        }
        let bucketRecords = defaults.integer(forKey: "bucket")
        numberOfRecordsInBucket.setTitle(String(bucketRecords), for: .normal)
        tableView.reloadData()
    }
    
    @IBAction func goToFavorites(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "FavoriteStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        vc.allRecords = allRecords
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func sortNameDown(_ sender: UIButton) {
        allRecords = Utils.sortByNameDown(records: allRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortNameUp(_ sender: UIButton) {
        allRecords = Utils.sortByNameUp(records: allRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
        
    }
    
    @IBAction func sortPriceDown(_ sender: UIButton) {
        allRecords = Utils.sortByPriceDown(records: allRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortPriceUp(_ sender: UIButton) {
        allRecords = Utils.sortByPriceUp(records: allRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortDateDown(_ sender: UIButton) {
        allRecords = Utils.sortByDateDown(records: allRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
        
    }
    
    @IBAction func sortDateUp(_ sender: UIButton) {
        
        allRecords = Utils.sortByDateUp(records: allRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    
    func changeButtonBackgroundColor(sender: UIButton){
        for button in sortingButtons{
            if (button == sender){
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
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
        if allRecords[indexPath.row].isFavorite {
            cell.favoriteButton.setImage(UIImage(named: "red"), for: .normal)
        } else {
            cell.favoriteButton.setImage(UIImage(named: "White"), for: .normal)
        }
        let recordPrice = Utils.splitPrice(price: allRecords[indexPath.row].price!)
        cell.recordMainPrice.text = String(recordPrice[0])
        cell.recordSubPrice.text = String(recordPrice[1])
        
        
        
        
        return cell
    }
    
    func didSelectRecord(_ id: Int) {
        
        for record in allRecords {
            if record.id == id {
                record.isFavorite = true
                break
            }
        }
        
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
