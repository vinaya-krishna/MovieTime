//
//  MovieViewController.swift
//  MovieTime
//
//  Created by MovieTime on 09/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class MovieViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    
    var estimateWidth = 160.0
    var cellmarginSize = 16.0
    var nowPlayingMovieRes:MovieResults?
    var searchMovieRes:MovieResults?
    var page = 1
    
    var nowPlayingMovieList = [MovieInfo]()
    var searchMovieList = [MovieInfo]()
    var userSearch = false
    

    @IBAction func onLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginController") as! LoginController
            self.present(loginController, animated: true, completion: nil)
        } catch let err {
            print(err)
        }
        
        
    }
    
    
    func loadNowPlayingMovies(){
        SVProgressHUD.show()
        APIService.nowPlaying(page: self.page) { (results:MovieResults) in
            self.nowPlayingMovieRes = results
            if let moreMovies = results.results{
                self.nowPlayingMovieList += moreMovies
            }
            
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func loadSearchMovies(query:String){
        SVProgressHUD.show()
        APIService.searchMovie(page: 1,query: query) { (results:MovieResults) in
            self.searchMovieRes = results
            if let moreMovies = results.results{
                if moreMovies.count == 0{
                    DispatchQueue.main.async {
                        self.view.makeToast("No Results Found!")
                    }
                }
                self.searchMovieList = moreMovies
                
            }
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.loadNowPlayingMovies()
        

        self.movieCollection.delegate = self
        self.movieCollection.dataSource = self
        self.movieCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        self.setupGridView()
        
    }
    
    func setupGridView(){
        let flow = movieCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellmarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellmarginSize)
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let cell = sender as! UICollectionViewCell
        if let index = self.movieCollection.indexPath(for: cell){
            if let destination = segue.destination as? MovieDetailsController {
                if(self.userSearch == true){
//                    destination.selectedMovie = self.searchMovieList[index.row]
                    destination.selectedMovieId = self.searchMovieList[index.row].id
                }
                else{
//                     destination.selectedMovie = self.nowPlayingMovieList[index.row]
                    destination.selectedMovieId = self.nowPlayingMovieList[index.row].id
                }
               
            }
        }
    }
}

extension MovieViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.userSearch == true{
            return self.searchMovieList.count
        }
        else{
            return self.nowPlayingMovieList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell

        var movie:MovieInfo?
        if(self.userSearch == true){
            movie = self.searchMovieList[indexPath.row]
        }
        else{
            movie = self.nowPlayingMovieList[indexPath.row]
        }
        
        if let movie_one = movie{
            guard let path = movie_one.poster_path else{
                cell.setDefault()
                return cell
            }
            
            let imageTumbURL = APIService.smallImageURL(path: path)
            cell.setData(imageURL:imageTumbURL!)
        }
        return cell
    }
}

extension MovieViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = self.calculateWidth()
        return CGSize(width: width, height: width+50.0)
    }
    func calculateWidth()->CGFloat{
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width/estimatedWidth))
        let margin = CGFloat(cellmarginSize*2)
        let width = (self.view.frame.size.width - CGFloat(cellmarginSize)*(cellCount-1)-margin)/cellCount
        return width
    }
}

extension MovieViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if(self.userSearch == false){
            if(indexPath.row == self.nowPlayingMovieList.count - 1){
                if ((self.nowPlayingMovieRes?.total_pages)! > self.page){
                    self.page += 1
                    self.loadNowPlayingMovies()
                }
            }
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.movieCollection.cellForItem(at: indexPath)
        self.movieCollection.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "movieDetail", sender: cell)
    }
}

extension MovieViewController:UISearchBarDelegate{
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        userSearch = true
        self.view.endEditing(true)
        if let searchText = searchBar.text{
            let urlString = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if let searchStr = urlString{
                self.loadSearchMovies(query: searchStr)
            }
            else{
                self.view.makeToast("Something is wrong!")
            }
        }
        else{
            self.view.makeToast("Something is wrong!")
        }

    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.view.endEditing(true)
        searchBar.text = ""
        userSearch = false
        self.searchMovieList.removeAll()
        self.movieCollection.reloadData()
    }
    
    
}
