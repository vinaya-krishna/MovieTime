//
//  MovieDetailsController.swift
//  MovieTime
//
//  Created by MovieTime on 10/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SafariServices
import Toast_Swift

class MovieDetailsController: UIViewController {

    var selectedMovie:MovieInfo?
    var movieResults:Movie?
    var cast:[Cast]?
    var crew:[Crew]?
    
    var selectedMovieId:Int?
    
    
    var videoList:[Videos]?
    
    var user = Auth.auth().currentUser
    var ref: DatabaseReference!
    
    var watchlistMovie:[String:Any]!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var movieCoverImage: UIImageView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var castCollection: UICollectionView!
    @IBOutlet weak var crewCollection: UICollectionView!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var castViewHeight: NSLayoutConstraint!
    @IBOutlet weak var crewViewHeight: NSLayoutConstraint!
    
    @IBAction func addtoWatchList(_ sender: UIButton) {
        watchlistMovie = [
            "id":movieResults?.id as Any,
            "title": movieResults?.title as Any,
            "poster_path":movieResults?.poster_path as Any,
            "release_date":movieResults?.release_date as Any
        ]
        if let movieId = self.movieResults?.id{
            self.ref.child("watchlist").child(user!.uid).child("\(movieId)").setValue(watchlistMovie)
        }
        self.view.makeToast("Added to Your WatchList !")
    }
    

    @IBAction func onReviews(_ sender: UIButton) {
        performSegue(withIdentifier: "reviewSeg", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
//        self.title = self.selectedMovie?.title
//        self.releaseDate.text = self.selectedMovie?.release_date
        
        self.castCollection.register(UINib(nibName: "CreditCell", bundle: nil), forCellWithReuseIdentifier: "CreditCell")
        self.crewCollection.register(UINib(nibName: "CreditCell", bundle: nil), forCellWithReuseIdentifier: "CreditCell")
        self.videoCollection.register(UINib(nibName: "CreditCell", bundle: nil), forCellWithReuseIdentifier: "CreditCell")
        
        self.castCollection.delegate = self
        self.castCollection.dataSource = self
        self.crewCollection.delegate = self
        self.crewCollection.dataSource = self
        self.videoCollection.delegate = self
        self.videoCollection.dataSource = self
        
        APIService.movieDetail(movieID: (selectedMovieId)!) { (movieRes:Movie) in
            self.movieResults = movieRes
            DispatchQueue.main.async {
            
                self.movieTitle.text = self.movieResults?.title
                self.summary.text = self.movieResults!.overview
                if let runtime = self.movieResults?.runtime{
                    self.runtime.text = "\(runtime) min"
                }
                if let rating = self.movieResults?.vote_average{
                    self.rating.text = "\(rating)/10 "
                }
                if let title = self.movieResults?.title{
                    self.title = title
                }
                if let releaseDate = self.movieResults?.release_date{
                    self.releaseDate.text = releaseDate
                }
                if let path = self.movieResults?.poster_path{
                    let coverImageURL = APIService.bigImageURL(path: path)
                    self.movieCoverImage.sd_setImage(with: coverImageURL!, placeholderImage: UIImage(named: "movie_placeholder.png"))
                    self.movieCoverImage.contentMode = .scaleAspectFit
                }
                else{
                    self.movieCoverImage.image = UIImage(named: "movie_placeholder.png")
                }
            }
        }
        
        
        APIService.movieCredits(movieID: (selectedMovieId)!) { (credits: Credits) in
        
            if let cast = credits.cast{
                self.cast = cast
            }
            if let crew = credits.crew{
                self.crew = crew
            }
            
            DispatchQueue.main.async {
                if self.cast?.count == 0{
                    self.castViewHeight.constant = 0.0
                }
                if self.crew?.count == 0{
                    self.crewViewHeight.constant = 0.0
                }
                self.castCollection.reloadData()
                self.crewCollection.reloadData()
            }
        }
        
        APIService.movieVideos(movieID: (selectedMovieId)!) { (videos: VideoInfo) in
            if let allVideos = videos.results{
                self.videoList = allVideos
                DispatchQueue.main.async {
                    if self.videoList?.count == 0 {
                        self.videoViewHeight.constant = 0.0
                    }
                    self.videoCollection.reloadData()
                }
            }
        }
        
    
//        if let movie = selectedMovie{
//            if let path = movie.poster_path{
//                let coverImageURL = APIService.bigImageURL(path: path)
//                self.movieCoverImage.sd_setImage(with: coverImageURL!, placeholderImage: UIImage(named: "movie_placeholder.png"))
//                self.movieCoverImage.contentMode = .scaleAspectFit
//            }
//        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReviewController{
            destination.movieId = selectedMovieId
        }
    }


}

extension MovieDetailsController:UICollectionViewDelegate{
    
}

extension MovieDetailsController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.castCollection{
            if let number = self.cast?.count{
                return number
            }
            else{
                return 0
            }
        }
        if collectionView == self.crewCollection{
            if let number = self.crew?.count{
                return number
            }
            else{
                return 0
            }
        }
        if collectionView == self.videoCollection{
            if let number = self.videoList?.count{
                return number
            }
            else{
                return 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreditCell", for: indexPath) as! CreditCell

        if collectionView == self.castCollection{
            let cast_one = self.cast?[indexPath.row]
            if let cast = cast_one{
                if let path = cast.profile_path{
                    let castImageURL = APIService.smallImageURL(path: path)
                    castCell.setData(imageURL: castImageURL!)
                }
                else{
                    castCell.setDefault()
                }
                castCell.setNames(castName: cast.character!, realName: cast.name!)
            }
            castCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCast(_:))))
        }
            
        if collectionView == self.crewCollection{
            let crew_one = self.crew?[indexPath.row]
            if let crew = crew_one{
                if let path = crew.profile_path{
                    let crewImageURL = APIService.smallImageURL(path: path)
                    castCell.setData(imageURL: crewImageURL!)
                }
                else{
                    castCell.setDefault()
                }
                castCell.setNames(castName: crew.department!, realName: crew.name!)
            }
            castCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCrew(_:))))
        }
        if collectionView == self.videoCollection{
            let video_one = self.videoList![indexPath.row]
            if let video_key = video_one.key{
                let videoThumbURL = APIService.youtubeThumb(path: video_key)
                if let videoImg = videoThumbURL{
                    castCell.setVideoImage(imageURL: videoImg)
                }
            }
            castCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapVideo(_:))))
        }

        return castCell
    
    }
    
    @objc func tapVideo(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.videoCollection)
        let indexPath = self.videoCollection.indexPathForItem(at: location)
        
        if let index = indexPath {
            let video_one = self.videoList![index[1]]
            if let video_key = video_one.key{
                let videoURL = APIService.youtubeURL(path: video_key)
                if let videourl = videoURL{
                    print(videourl)
                
                    let safariVC = SFSafariViewController(url: videourl)
                    present(safariVC, animated: true, completion: nil)
                }
            }
            
            
        }
    }

    @objc func tapCast(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.castCollection)
        let indexPath = self.castCollection.indexPathForItem(at: location)

        if let index = indexPath {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileController = storyBoard.instantiateViewController(withIdentifier: "profileController") as! ProfileController
            
            if let cast = self.cast?[index[1]]{
                profileController.personID = cast.id
            }
            
            self.navigationController?.pushViewController(profileController, animated: true)
            
            
        }
    }
    @objc func tapCrew(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.crewCollection)
        let indexPath = self.crewCollection.indexPathForItem(at: location)

        if let index = indexPath {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
        
            let profileController = storyBoard.instantiateViewController(withIdentifier: "profileController") as! ProfileController
            
            if let crew = self.crew?[index[1]]{
                profileController.personID = crew.id
            }
            
            self.navigationController?.pushViewController(profileController, animated: true)
        }
    }
    
}
