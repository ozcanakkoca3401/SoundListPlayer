//
//  FavoriteViewController.swift
//  RTE
//
//  Created by Özcan AKKOCA on 12.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class FavoriteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var rTECategory:RTECategory?
    var rteDB: [RteDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rTECategory = RTECategory()
        self.title = "Favoriler"
          self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.tableView.tableFooterView = UIView()

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rteDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        let rte = rteDB[indexPath.row]
        
        if let myName = rte.key {
            cell.textLabel?.text = myName
            cell.textLabel?.textColor = UIColor.white
            cell.selectionStyle = .none

        }
        
        return cell
    }
    
    func getData() {
        do {
            rteDB = try context.fetch(RteDB.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let rteDb = rteDB[indexPath.row]
            context.delete(rteDb)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                rteDB = try context.fetch(RteDB.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoritePopUpSegue" {
            if let viewController = segue.destination as? PopUpViewController {
                let index = tableView.indexPathForSelectedRow?.row
                
                let rteDb = rteDB[index!]

                viewController.detailKey = rteDb.key
                viewController.detailValue = rteDb.value
                
            }
        }
    }
}

