//
//  WatchlistViewController.swift
//  MovieTime
//
//  Created by MovieTime on 15/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import EventKit
import Toast_Swift



class WatchlistViewController: UIViewController {

    var ref: DatabaseReference!
    var refHandle:DatabaseHandle?
    var watchListData = [[String:Any]]()
    @IBOutlet weak var watchListTable: UITableView!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        self.ref = Database.database().reference()
        self.watchListData.removeAll()
        self.watchListTable.reloadData()
        refHandle = self.ref.child("watchlist").child(self.userID!).observe(.childAdded, with: { (snapshot) in
            SVProgressHUD.show()
            let postDict = snapshot.value as? [String : Any] ?? [:]
            self.watchListData.append(postDict)
            DispatchQueue.main.async {
                self.watchListTable.reloadData()
                SVProgressHUD.dismiss()
            }
        })
        
    }
}


extension WatchlistViewController:WatchlistCellDelegate{
    
    func didTapRemoveItem(movieId: Int) {
        SVProgressHUD.show()
        self.didTapRemoveCalender(movieId: movieId)
        self.watchListData.removeAll()
        
        self.ref.child("watchlist").child(self.userID!).child("\(movieId)").removeValue()
        refHandle = self.ref.child("watchlist").child(self.userID!).observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.value as? [String : Any] ?? [:]
            self.watchListData.append(postDict)
            DispatchQueue.main.async {
                self.view.makeToast("Deleted From Watchlist")
                self.watchListTable.reloadData()
            }
            SVProgressHUD.dismiss()
        })
        DispatchQueue.main.async {
            self.watchListTable.reloadData()
            SVProgressHUD.dismiss()
        }
        
    }
    
    func didTapAddCalender(movieId: Int, movieTitle:String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dateController = storyboard.instantiateViewController(withIdentifier: "datePopup") as! DateViewController
        
        dateController.movieId = movieId
        dateController.movieTitle = movieTitle
        self.present(dateController, animated: true,completion:nil)
    }
    
    func didTapRemoveCalender(movieId: Int) {
        self.ref.child("wishlistcalender").child(self.userID!).child("\(movieId)").observeSingleEvent(of: .value, with: { (snapshot) in
           let eventStore : EKEventStore = EKEventStore()
            if let eventID = snapshot.value as? String{
                
                if let calendarEvent_toDelete = eventStore.event(withIdentifier: eventID){
                    do{
                        try eventStore.remove(calendarEvent_toDelete, span: EKSpan.thisEvent)
                        self.ref.child("wishlistcalender").child(self.userID!).child("\(movieId)").removeValue()
                        DispatchQueue.main.async {
                            self.view.makeToast("Removed From Calender")
                        }
                    } catch let e as NSError{
                        print(e)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}

extension WatchlistViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = self.watchListData[indexPath.row]
        let watchListCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! WatchlistCell
        
        watchListCell.setDetails(watchData: movie)
        watchListCell.delegate = self
        
        self.ref.child("wishlistcalender").child(self.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let watchListCalender = snapshot.value as? [String : String] ?? [:]
            if let id = watchListCell.watchItem["id"] as? Int{
                if watchListCalender.keys.contains("\(id)"){
                    print("Yes")
                    watchListCell.removeFromCalButton.isHidden = false
                    watchListCell.addtoCalButton.isHidden = true
                }
                else{
                    watchListCell.removeFromCalButton.isHidden = true
                    watchListCell.addtoCalButton.isHidden = false
                }
            }

        })
        return watchListCell
    }
    
    
}

extension WatchlistViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245.0
        
    }
}


