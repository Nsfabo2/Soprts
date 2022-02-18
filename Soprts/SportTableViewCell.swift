//
//  SportTableViewCell.swift
//  Soprts
//
//  Created by Najla on 17/01/2022.
//

import UIKit

class SportTableViewCell: UITableViewCell {
    //outlets
    @IBOutlet weak var SportImagePicker: UIImageView!
    @IBOutlet weak var SportName: UILabel!
    @IBOutlet weak var AddImage: UIButton!
    //variables
    var delegate: ImageDelegate?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func AddSportImage(_ sender: Any) {
        delegate?.pickImage(indexPath: indexPath!)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
