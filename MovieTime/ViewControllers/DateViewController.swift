//
//  DateViewController.swift
//  MovieTime
//
//  Created by MovieTime on 15/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import EventKit


class DateViewController: UIViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    var movieTitle:String?
    var movieId:Int?
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    @IBAction func onSaveDate(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY HH:mm"
        let mDate = datePicker.date
        
        
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                
                event.title = self.movieTitle
                event.startDate = mDate
                event.endDate = mDate
                event.notes = "Let's watch this movie"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    print(e)
                    return
                }
                
                DispatchQueue.main.async {
                    let interval = mDate.timeIntervalSinceReferenceDate
                    if let url = URL(string: "calshow:\(interval)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                    }
                    
                    self.view.makeToast("Successfully Added to Calender!")
                }
                
                
                if let userid = self.userID, let mId = self.movieId{
                    print(userid)
                    print(mId)
                    self.ref.child("wishlistcalender").child(userid).child("\(mId)").setValue(event.eventIdentifier)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.view.makeToast("Something wrong!")
                }
            }
        }
       
        dismiss(animated: true)
        
                
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
    }
}
