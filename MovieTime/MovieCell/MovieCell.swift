//
//  MovieCell.swift
//  MovieTime
//
//  Created by MovieTime on 09/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {


    @IBOutlet weak var movieImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(imageURL:URL){
        movieImage.sd_setShowActivityIndicatorView(true)
        movieImage.sd_setIndicatorStyle(.gray)
        movieImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "movie_placeholder.png"))
    }
    func setDefault(){
        movieImage.image = UIImage(named: "movie_placeholder.png")
    }
    

}
