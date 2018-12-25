//
//  Services.swift
//  MovieTime
//
//  Created by MovieTime on 16/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation
import UIKit

func makeAlert(title:String, message:String)->UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
}


