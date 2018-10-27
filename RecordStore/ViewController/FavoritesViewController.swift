//
//  FavoritesViewController.swift
//  Grapes'n'berries
//
//  Created by Champion on 10/22/18.
//  Copyright © 2018 ITI. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var allRecords = [Record]()
    var favoriteRecords = [Record]()
    var favoriteArray = [Int]()
    
    @IBOutlet var sortingButtons: [UIButton]!
    
    @IBOutlet weak var isFavoriteButton: UIButton!
    @IBOutlet weak var numberOfRecordsInBucket: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteArray = defaults.array(forKey: "favoriteRecords")  as? [Int] ?? [Int]()
        getFavoriteRecords()
        let bucketRecords = defaults.integer(forKey: "bucket")
        numberOfRecordsInBucket.setTitle(String(bucketRecords), for: .normal)
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sortNameDown(_ sender: UIButton) {
        favoriteRecords = Utils.sortByNameDown(records: favoriteRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    
    @IBAction func sortNameUp(_ sender: UIButton) {
        favoriteRecords = Utils.sortByNameUp(records: favoriteRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortPriceDown(_ sender: UIButton) {
        favoriteRecords = Utils.sortByPriceDown(records: favoriteRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortPriceUp(_ sender: UIButton) {
        favoriteRecords = Utils.sortByPriceUp(records: favoriteRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortDateDown(_ sender: UIButton) {
        favoriteRecords = Utils.sortByDateDown(records: favoriteRecords)
        tableView.reloadData()
        changeButtonBackgroundColor(sender: sender)
    }
    
    @IBAction func sortDateUp(_ sender: UIButton) {
        favoriteRecords = Utils.sortByDateUp(records: favoriteRecords)
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
    
    func getFavoriteRecords(){
        favoriteRecords = [Record]()
        for id in favoriteArray {
            for record in allRecords {
                if record.id == id{
                    favoriteRecords.append(record)
                    
                }
            }
        }
        favoriteRecords = Utils.sortByPriceDown(records: favoriteRecords)
        tableView.reloadData()
    }
    
}

// MARK: - Table view data source

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoCell", for: indexPath) as! FavoriteTableViewCell
        cell.favoriteCellDelegate = self
        
        cell.recordId = favoriteRecords[indexPath.row].id!
        cell.title.text = favoriteRecords[indexPath.row].title
        cell.artist.text = favoriteRecords[indexPath.row].artist
        cell.price.text = String(favoriteRecords[indexPath.row].price!)
        cell.recordImage.sd_setImage(with: URL(string: favoriteRecords[indexPath.row].image!), placeholderImage: UIImage(named: "record1"))
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailsStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsTableViewController") as! DetailsTableViewController
        vc.myRecord = favoriteRecords[indexPath.row]
        present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: FavoriteCellDelegate {
    func removeFromFavorite(id: Int) {
        for index in 0..<favoriteRecords.count{
            if favoriteRecords[index].id == id {
                favoriteRecords.remove(at: index)
                tableView.reloadData()
                break
            }
        }
        for index in 0..<favoriteArray.count {
            if favoriteArray[index] == id {
                favoriteArray.remove(at: index)
                break
            }
        }
        defaults.set(favoriteArray, forKey: "favoriteRecords")
        
    }
    
    
}
