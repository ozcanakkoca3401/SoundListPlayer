//
//  ViewController.swift
//  RTE
//
//  Created by Özcan AKKOCA on 5.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
@available(iOS 10.0, *)

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var rTECategory:RTECategory?
    var listDetailNameVC: String?
    var player : AVAudioPlayer?
    var detailDict: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rTECategory = RTECategory()
        categoryDetail(listDetailName: listDetailNameVC!, rteCategory: rTECategory!)
        bannerViewAdmob()
        print(listDetailNameVC!)
    }
    
    // Section sayısı 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Listede kaç eleman bulunacağı.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailDict?.count)!
    }
    
    // Cell oluşturma ve bağlantısı
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = detailDict?.allKeys[indexPath.row] as? String
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUpSegue" {
            if let viewController = segue.destination as? PopUpViewController {
                let index = tableView.indexPathForSelectedRow?.row
                
                print(detailDict?.allValues[index!] as Any)
                viewController.detailKey = detailDict?.allKeys[index!] as? String
                viewController.detailValue = detailDict?.allValues[index!] as? String

            }
        }
    }
    
    func bannerViewAdmob () {
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-3678993859791859/7541644950" // admobdan alıcağın Reklam id buraya yapıştır.
        bannerView.rootViewController = self //bu ekranı Root olarak kabul eder.
        bannerView.load(GADRequest()) // Reklamı yükle
    }
    
    func categoryDetail(listDetailName: String, rteCategory: RTECategory) {
        switch listDetailName {
        case "Genel 1":
            detailDict = rteCategory.genel1Dict
        case "Genel 2":
            detailDict = rteCategory.genel2Dict
        case "Genel 3":
            detailDict = rteCategory.genel3Dict
        case "Meclis":
            detailDict = rteCategory.meclisDict
        case "Muhalefet":
            detailDict = rteCategory.muhalefetDict
        case "Meydan 1":
            detailDict = rteCategory.meydan1Dict
        case "Meydan 2":
            detailDict = rteCategory.meydan2Dict
        case "Meydan 3":
            detailDict = rteCategory.meydan3Dict
        case "Uluslararası":
            detailDict = rteCategory.uluslararasiDict
        case "Avrupa":
            detailDict = rteCategory.avrupaDict
        case "Basın":
            detailDict = rteCategory.basinDict
        case "Ekonomi":
            detailDict = rteCategory.ekonomiDict
        case "Bunlar":
            detailDict = rteCategory.bunlarDict
        case "Eyy":
            detailDict = rteCategory.eyyDict
        case "Karadeniz Ağzı":
            detailDict = rteCategory.karadenizagziDict
        case "15 Temmuz":
            detailDict = rteCategory.temmuz15Dict
        case "Referandum":
            detailDict = rteCategory.referandumDict
        default:
            print("Hata")
        }
        
    }


}

