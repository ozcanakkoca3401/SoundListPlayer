//
//  AppDelegate.swift
//  RTE
//
//  Created by Özcan AKKOCA on 5.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
//

import Foundation
import XLPagerTabStrip
@available(iOS 10.0, *)

class ChildListViewController: UIViewController, IndicatorInfoProvider {

    var itemInfo: IndicatorInfo = "View"
 
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
         super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.itemInfo.title)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ListTableViewController = storyboard.instantiateViewController(withIdentifier: "someViewController") as! ListTableViewController
        controller.listDetailNameVC = self.itemInfo.title
        controller.view.frame = self.view.bounds;
        controller.willMove(toParentViewController: self)
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)

    }
    

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
