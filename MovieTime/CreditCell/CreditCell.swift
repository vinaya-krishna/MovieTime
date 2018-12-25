//
//  CreditCell.swift
//  MovieTime
//
//  Created by MovieTime on 13/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import SDWebImage

class CreditCell: UICollectionViewCell {
    
    @IBOutlet weak var creditImage: UIImageView!
    @IBOutlet weak var realName: UILabel!
    @IBOutlet weak var castName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(imageURL:URL){
        
//        creditImage.load(url: imageURL)
        creditImage.layer.cornerRadius = creditImage.frame.size.height/2
        creditImage.clipsToBounds = true
        
//        creditImage.load(url: imageURL)
        
        creditImage.sd_setShowActivityIndicatorView(true)
        creditImage.sd_setIndicatorStyle(.gray)
        
        creditImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder.png"))
      
    
        
    }
    
    func setDefault(){
        creditImage.layer.cornerRadius = creditImage.frame.size.height/2
        creditImage.clipsToBounds = true
        creditImage.image = UIImage(named: "placeholder.png")
    }
    
    
    func setVideoImage(imageURL:URL){

        
        creditImage.sd_setShowActivityIndicatorView(true)
        creditImage.sd_setIndicatorStyle(.gray)
        creditImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        
        
        
    }
    
    
    
    
    
    
    func setNames(castName:String, realName:String){
        self.realName.text = realName
        self.castName.text = castName
    }

}
