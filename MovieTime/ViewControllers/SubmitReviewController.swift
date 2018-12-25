//
//  SubmitReviewController.swift
//  MovieTime
//
//  Created by MovieTime on 18/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SubmitReviewController: UIViewController {

    
    var movieId:Int?
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser!.uid
    var userName:String?
    
    @IBOutlet weak var reviewContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.ref = Database.database().reference()
            self.ref.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userData = snapshot.value as? [String:String]{
                if let name = userData["name"]{
                    self.userName = name
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        

    }

    @IBAction func onCancel(_ sender: Any) {
        self.view.makeToast("Review Canceled")
        dismiss(animated: true)
    }
    @IBAction func onSubmitReview(_ sender: UIButton) {
        
        if let reviewText = reviewContent.text, let mID = movieId, let author=userName{
            
            let reviewData = [
                "content": reviewText,
                "author": author
            ]
            self.ref.child("reviews").child("\(mID)").child("\(self.userID)").setValue(reviewData)
        }
        
        self.view.makeToast("Review Submitted Successfully")
        dismiss(animated: true)
    }
}
