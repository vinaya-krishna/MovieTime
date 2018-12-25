//
//  PersonCredits.swift
//  MovieTime
//
//  Created by MovieTime on 17/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation

struct CastData:Codable {
    var poster_path:String?
    var id:Int?
}

struct CrewData:Codable {
    var poster_path:String?
    var id:Int?
}

struct PersonCredits:Codable {
    var id: Int?
    var cast:[CastData]?
    var crew:[CrewData]?
}
