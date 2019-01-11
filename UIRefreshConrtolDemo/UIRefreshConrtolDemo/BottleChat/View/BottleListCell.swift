//
//  BottleListCell.swift
//  XCamera
//
//  Created by 张泽 on 2018/12/27.
//  Copyright © 2018 xhey. All rights reserved.
//

import UIKit

class BottleListCell: UITableViewCell {

    @IBOutlet weak var nameLB: UILabel!

    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var infoHint: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
