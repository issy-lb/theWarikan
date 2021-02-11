//
//  eventTableViewCell.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import UIKit

class eventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
