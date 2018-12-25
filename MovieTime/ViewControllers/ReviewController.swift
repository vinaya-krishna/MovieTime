//
//  ReviewController.swift
//  MovieTime
//
//  Created by MovieTime on 17/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class ReviewController: UIViewController {

    @IBOutlet weak var reviewTable: UITableView!
    var selectedIndex:Int?
    var movieId:Int?
    var ref: DatabaseReference!
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.reviewTable.delegate = self
        self.reviewTable.dataSource = self
        
//        SVProgressHUD.show()
//        APIService.movieReviews(page: 1, movieID: self.movieId!) { (allReview: ReviewRes) in
//            if let reviewres = allReview.results{
//                self.reviews = reviewres
//                DispatchQueue.main.async {
//                    SVProgressHUD.dismiss()
//                    self.reviewTable.reloadData()
//                }
//            }
//        }
//
//        self.ref.child("reviews").child("\(self.movieId!)").observe(.childAdded, with: { (snapshot) in
//
//            let reviewDict = snapshot.value as? [String : String] ?? [:]
//            let reviewStruct = Review(author: reviewDict["author"]!, content: reviewDict["content"]!, id: "nil")
//            self.reviews.append(reviewStruct)
//            DispatchQueue.main.async {
//                self.reviewTable.reloadData()
//            }
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.show()
        APIService.movieReviews(page: 1, movieID: self.movieId!) { (allReview: ReviewRes) in
            if let reviewres = allReview.results{
                self.reviews = reviewres
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.reviewTable.reloadData()
                }
            }
        }
        
        self.ref.child("reviews").child("\(self.movieId!)").observe(.childAdded, with: { (snapshot) in
            
            let reviewDict = snapshot.value as? [String : String] ?? [:]
            let reviewStruct = Review(author: reviewDict["author"]!, content: reviewDict["content"]!, id: "nil")
            self.reviews.append(reviewStruct)
            DispatchQueue.main.async {
                self.reviewTable.reloadData()
            }
        })
    }

    @IBAction func onWriteReview(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let submitReviewController = storyboard.instantiateViewController(withIdentifier: "writeReview") as! SubmitReviewController
        
        submitReviewController.movieId = movieId
        self.present(submitReviewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onViewMore(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.reviewTable)
        if let indexPath = self.reviewTable.indexPathForRow(at: buttonPosition) {
            self.selectedIndex = indexPath.row // store the index of "view more" pressed
            self.reviewTable.reloadData() // reload the tableview to reflect the change
        }
        
    }
    
}

extension ReviewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.reviewTable.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        
        let review = self.reviews[indexPath.row]
        if let content = review.content, let author = review.author{
            cell.reviewText.text = content
            cell.authorLabel.text = author
        }
        
        
        if self.selectedIndex != nil, indexPath.row == self.selectedIndex {
            cell.reviewText.numberOfLines = 0 // show full review for selected index
            cell.viewMoreButton.isHidden = true // and hide the "view more" button
        } else {
            cell.reviewText.numberOfLines = 2 // show only 2 lines for other index
            cell.viewMoreButton.isHidden = false // and show the "view more" button
        }
        cell.selectionStyle = .none
         return cell
    }
   
    
}


extension ReviewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


