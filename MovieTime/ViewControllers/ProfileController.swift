//
//  ProfileController.swift
//  MovieTime
//
//  Created by MovieTime on 17/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileController: UIViewController {

    var personID:Int?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var birthdayText: UILabel!
    @IBOutlet weak var castCollection: UICollectionView!
    @IBOutlet weak var crewCollection: UICollectionView!

    
    @IBOutlet weak var crewCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var castCollectionHeight: NSLayoutConstraint!
    var cast = [CastData]()
    var crew = [CrewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.castCollection.delegate = self
//        self.crewCollection.delegate = self
        self.castCollection.dataSource = self
        self.crewCollection.dataSource = self
        
         self.castCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
         self.crewCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        APIService.personDetails(personID: self.personID!) { (personRes: Person) in
            print(personRes)
            
            if let name = personRes.name{
                DispatchQueue.main.async {
                    self.nameText.text = name
                }
            }
            if let birthday = personRes.birthday{
                DispatchQueue.main.async {
                    self.birthdayText.text = "Birth Date : \(birthday)"
                }
            }
            if let path = personRes.profile_path{
                DispatchQueue.main.async {
                    let coverImageURL = APIService.smallImageURL(path: path)
                    self.profileImage.sd_setImage(with: coverImageURL!, placeholderImage: UIImage(named: "placeholder.png"))
                    self.profileImage.contentMode = .scaleAspectFit
                }
            }
            else{
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(named: "placeholder.png")
                }
            }
        }
        
        APIService.personMovieCredits(personID: self.personID!) { (personCredit:PersonCredits) in
            if let cast = personCredit.cast{
                self.cast = cast
            }
            if let crew = personCredit.crew{
                self.crew = crew
            }
            DispatchQueue.main.async {
                if self.crew.count == 0{
                    self.crewCollectionHeight.constant = 0.0
                }
                if self.cast.count == 0{
                    self.castCollectionHeight.constant = 0.0
                }
                self.castCollection.reloadData()
                self.crewCollection.reloadData()
            }
        }
    }
}



extension ProfileController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.castCollection{
           return self.cast.count
        }
        if collectionView == self.crewCollection{
            return self.crew.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell

        if collectionView == self.castCollection{
            let cast_one = self.cast[indexPath.row]
           
            if let path = cast_one.poster_path{
                let castImageURL = APIService.smallImageURL(path: path)
                movieCell.setData(imageURL: castImageURL!)
            }
            else{
                movieCell.setDefault()
            }
            movieCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCast(_:))))
        }

        if collectionView == self.crewCollection{
            let crew_one = self.crew[indexPath.row]
          
            if let path = crew_one.poster_path{
                let crewImageURL = APIService.smallImageURL(path: path)
                movieCell.setData(imageURL: crewImageURL!)
            }
            else{
                movieCell.setDefault()
            }
            movieCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCrew(_:))))
        }

        return movieCell
    }
    
    @objc func tapCast(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.castCollection)
        let indexPath = self.castCollection.indexPathForItem(at: location)
   
        if let index = indexPath {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let movieDetailsController = storyBoard.instantiateViewController(withIdentifier: "movieDetailsController") as! MovieDetailsController
        
            movieDetailsController.selectedMovieId = self.cast[index[1]].id
            self.navigationController?.pushViewController(movieDetailsController, animated: true)
            
            
        }
    }
    
    @objc func tapCrew(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.crewCollection)
        let indexPath = self.crewCollection.indexPathForItem(at: location)
     
        if let index = indexPath {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let movieDetailsController = storyBoard.instantiateViewController(withIdentifier: "movieDetailsController") as! MovieDetailsController
            
            movieDetailsController.selectedMovieId = self.crew[index[1]].id
            self.navigationController?.pushViewController(movieDetailsController, animated: true)
            
            
        }
    }

    
}
