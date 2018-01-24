//
//  SearchViewController.swift
//  RTE
//
//  Created by Özcan AKKOCA on 12.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
//

import UIKit
@available(iOS 10.0, *)

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    var rTECategory:RTECategory?

    let searchBar = UISearchBar()
    
    var data = ["RTE Array"]
    
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        rTECategory = RTECategory()

        data = rTECategory?.fullDataDict.allKeys as! [String]
        filteredData = data
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Ara"
        self.navigationController?.navigationBar.tintColor = UIColor.white

        navigationItem.titleView = searchBar
        self.tableView.tableFooterView = UIView()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")! as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = data
        } else {
            filteredData = data.filter({(dataItem: String) -> Bool in
                if dataItem.range(of: searchText, options: .caseInsensitive) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchPopUpSegue" {
            if let viewController = segue.destination as? PopUpViewController {
                let index = tableView.indexPathForSelectedRow?.row
                
                viewController.detailKey = filteredData[index!]
                viewController.detailValue = rTECategory?.fullDataDict[filteredData[index!]] as? String//detailDict?.allValues[index!] as? String
                
            }
        }
    }
}

