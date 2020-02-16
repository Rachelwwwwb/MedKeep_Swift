//
//  WeatherTableViewController.swift
//  FinalProject
//
//  Created by Wenbei Wang on 2019/12/8.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController  {
    @IBOutlet weak var searchBar: UISearchBar!
    let userModel = travelModel.sharedInstance

    var listHistoryRecord = [Record](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "History Medical Records"
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        listHistoryRecord = userModel.tempUser.historyRecords
        editButtonItem.isEnabled = false
        //searchBar.delegate = self as! UISearchBarDelegate
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listHistoryRecord.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

       
        let rec = listHistoryRecord[indexPath.row]
        cell.textLabel?.text = "\(rec.date)"
        cell.detailTextLabel?.text = rec.keywords[0]
        return cell
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        if searchBar.isFirstResponder && touch?.view != searchBar {
            searchBar.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
//   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == selectedRowIndex.row {
//            return 100
//        }
//        return 70
//    }

//    // when search bar pressed, search using API
//   extension WeatherTableViewController : UISearchBarDelegate {
//       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//           guard let searchBarText = searchBar.text
//
//            else {return}
//        userModel.setKeywordTemp(keyword: searchBarText)
//        let wRequest = weatherRequest(cityName: searchBarText)
//
//        wRequest.getTemperature{[weak self] result in
//               switch result {
//               case .failure(let error):
//                   print (error)
//               case .success(let ws):
//                   self?.listWeatherObjc = ws
//               }
//           }
//
//
//       }
//   }

}
