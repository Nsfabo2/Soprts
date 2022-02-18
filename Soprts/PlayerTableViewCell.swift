//
//  PlayerTableViewCell.swift
//  Soprts
//
//  Created by Najla on 17/01/2022.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerAge: UILabel!
    @IBOutlet weak var PlayerHighet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
