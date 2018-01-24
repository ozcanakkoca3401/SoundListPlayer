//
//  ListTableViewCell.swift
//  RTE
//
//  Created by Özcan AKKOCA on 9.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var playIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
