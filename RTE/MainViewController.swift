//
//  MainViewController.swift
//  RTE
//
//  Created by Özcan AKKOCA on 5.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip
@available(iOS 10.0, *)

class MainViewController: TwitterPagerTabStripViewController {
    var isReload = false
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = ChildListViewController(itemInfo: "Genel 1")
        let child_2 = ChildListViewController(itemInfo: "Genel 2")
        let child_3 = ChildListViewController(itemInfo: "Genel 3")
        let child_4 = ChildListViewController(itemInfo: "Meclis")
        let child_5 = ChildListViewController(itemInfo: "Muhalefet")
        let child_6 = ChildListViewController(itemInfo: "Meydan 1")
        let child_7 = ChildListViewController(itemInfo: "Meydan 2")
        let child_8 = ChildListViewController(itemInfo: "Meydan 3")
        let child_9 = ChildListViewController(itemInfo: "Uluslararası")
        let child_10 = ChildListViewController(itemInfo: "Avrupa")
        let child_11 = ChildListViewController(itemInfo: "Basın")
        let child_12 = ChildListViewController(itemInfo: "Ekonomi")
        let child_13 = ChildListViewController(itemInfo: "Bunlar")
        let child_14 = ChildListViewController(itemInfo: "EYY")
        let child_15 = ChildListViewController(itemInfo: "Karadeniz Ağzı")
        let child_16 = ChildListViewController(itemInfo: "15 Temmuz")
        let child_17 = ChildListViewController(itemInfo: "Referandum")
        
        guard isReload else {
            return [child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8, child_9, child_10, child_11, child_12, child_13, child_14, child_15, child_16, child_17]
        }
        
        var childViewControllers = [child_1, child_2, child_3, child_4, child_6, child_7, child_8, child_9, child_10, child_11, child_12, child_13, child_14, child_15, child_16, child_17]
        
        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                swap(&childViewControllers[index], &childViewControllers[n])
            }
        }
        let nItems = 1 + (arc4random() % 17)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    

}
