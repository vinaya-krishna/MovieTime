//
//  Videos.swift
//  MovieTime
//
//  Created by MovieTime on 11/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation
struct Videos:Codable
{
    var id:String?
    var key:String?
    var name:String?
}

struct VideoInfo:Codable
{
    var id:Int?
    var results:[Videos]?
}
