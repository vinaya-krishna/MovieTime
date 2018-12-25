//
//  Reviews.swift
//  MovieTime
//
//  Created by MovieTime on 17/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation

struct Review:Codable
{
    var author:String?
    var content:String?
    var id:String?
    
    init(author:String, content:String,id:String) {
        self.author = author
        self.content = content
        self.id = id
    }
}



struct ReviewRes:Codable
{
    var id:Int?
    var results:[Review]?
    var total_pages:Int?
}
