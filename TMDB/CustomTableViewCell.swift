//
//  CustomTableViewCell.swift
//  TMDB
//
//  Created by Karthik Vadlamudi on 5/10/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
