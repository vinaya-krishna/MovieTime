//
//  WatchlistCell.swift
//  MovieTime
//
//  Created by MovieTime on 15/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase


protocol WatchlistCellDelegate {
    func didTapRemoveItem(movieId:Int)
    func didTapAddCalender(movieId: Int, movieTitle:String)
    func didTapRemoveCalender(movieId:Int)
}


class WatchlistCell: UITableViewCell {

    
    @IBOutlet weak var removeFromCalButton: UIButton!
    @IBOutlet weak var addtoCalButton: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    var delegate:WatchlistCellDelegate?
    var watchItem = [String:Any]()
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ref = Database.database().reference()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImage(imageUrl:URL){
        posterImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder.png"))
    }

    func setDetails(watchData:[String:Any]){
        watchItem = watchData
        if let pathStr = watchData["poster_path"] as? String{
            if let pathURL = APIService.smallImageURL(path: pathStr){
                self.setImage(imageUrl: pathURL)
            }
        }
        if let movieTitle = watchData["title"], let release = watchData["release_date"] {
            
            self.movieTitle.text = movieTitle as? String
            self.releaseDate.text = "Release Date : \(release as! String)"
        }
    }
    
    
    @IBAction func onAddToCalender(_ sender: Any) {
        if let id = watchItem["id"] as? Int, let mTitle = self.movieTitle.text{
            delegate?.didTapAddCalender(movieId: id, movieTitle: mTitle)
           
        }
    }
    
    @IBAction func onRemoveFromCalender(_ sender: Any) {
        if let id = watchItem["id"] as? Int{
            
            delegate?.didTapRemoveCalender(movieId: id)
            self.addtoCalButton.isHidden = false
            self.removeFromCalButton.isHidden = true
        }
        
    }
    
    @IBAction func onRemoveItem(_ sender: Any) {
        if let id = watchItem["id"] as? Int{
            delegate?.didTapRemoveItem(movieId: id)
        }
    }
    
    
}

