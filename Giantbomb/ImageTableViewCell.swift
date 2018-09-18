//
//  ImageTableViewCell.swift
//  Giantbomb
//
//  Created by HeAVeN on 9/18/18.
//  Copyright © 2018 HeAVeN. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var releaselbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
