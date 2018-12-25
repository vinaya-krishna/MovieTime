//
//  MovieAPI.swift
//  MovieTime
//
//  Created by MovieTime on 09/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation

struct MovieAPI {

    
    static let api_key = "bbe1b80e8f3ea5d974647cd23c79e065"
    static let basepath = "https://api.themoviedb.org/3"
//    static let endpath = "&language=en-US"
    
    static let smallImagePath = "https://image.tmdb.org/t/p/w185"
    static let bigImagePath = "https://image.tmdb.org/t/p/w342"
    static let youtubeThumb = "https://img.youtube.com/vi/"
    static let youtubeLink = "https://www.youtube.com/watch?v="
    
    
    static func getDataRequest(url:String, onCompletion:@escaping (Any)->()){
        let path = "\(basepath)\(url)"
        if let url = URL(string: path) {
            print(url)
            URLSession.shared.dataTask(with: url) {
                (data, response,error) in
                
                guard let data = data, error == nil, response != nil else{
                    print("Something is wrong")
                    return
                }
                onCompletion(data)
                }.resume()
        }
        else {
            print("Unable to create URL")
        }
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    static func postDataRequest(url:String, data:[String:Any], onCompletion:@escaping (Any)->()){
        
        let path = "\(basepath)\(url)"
        
        let jsonifiedData = try? JSONSerialization.data(withJSONObject: data)
        
        
        if let url = URL(string: path) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonifiedData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                guard let data = data, error == nil, response != nil else {
                    print("Something is wrong")
                    return
                }
                
                do {
                    let json:Any = try JSONSerialization.jsonObject(with: data, options: [])
                    onCompletion(json)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            task.resume();
        }
        else {
            print("Unable to create URL")
        }
    }
}
