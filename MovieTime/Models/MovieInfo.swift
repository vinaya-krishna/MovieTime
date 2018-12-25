//
//  MovieInfo.swift
//  MovieTime
//
//  Created by MovieTime on 09/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation

struct MovieInfo: Codable
{
    var id: Int?
    var poster_path: String?
    var title: String?
    var release_date:String?
}
struct MovieResults: Codable
{
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    var results: [MovieInfo]?
    
}
