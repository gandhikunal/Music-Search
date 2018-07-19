//
//  TrackViewCell.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import UIKit

class TrackViewCell: UITableViewCell {

    @IBOutlet weak var trackName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
