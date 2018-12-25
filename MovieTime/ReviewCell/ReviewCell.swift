//
//  ReviewCell.swift
//  MovieTime
//
//  Created by MovieTime on 17/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var reviewText: UILabel!
    
    @IBOutlet weak var viewMoreButton: UIButton!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
