//
//  Movie.swift
//  MovieTime
//
//  Created by MovieTime on 11/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation

struct Movie: Codable
{
    var id: Int?
    var title:String?
    var overview: String?
    var release_date: String?
    var runtime: Int?
    var vote_average:Float?
    var poster_path: String?
}
