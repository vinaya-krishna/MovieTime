//
//  APIServices.swift
//  MovieTime
//
//  Created by MovieTime on 09/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import Foundation

class APIService{
    
    static let api_key = "bbe1b80e8f3ea5d974647cd23c79e065"
    static let language = "en-US"
    
    
    static func nowPlaying(page:Int, completion: @escaping (MovieResults)->()) {
        
        let getURL = "/movie/now_playing?api_key=\(api_key)&language=\(language)&page=\(page)"
        
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(MovieResults.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    static func movieDetail(movieID:Int, completion: @escaping (Movie)->()) {
        
        let getURL = "/movie/\(movieID)?api_key=\(api_key)&language=\(language)"
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(Movie.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    static func movieVideos(movieID:Int, completion: @escaping (VideoInfo)->()) {
        
        let getURL = "/movie/\(movieID)/videos?api_key=\(api_key)&language=\(language)"
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(VideoInfo.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    
    static func movieCredits(movieID:Int, completion: @escaping (Credits)->()) {
        
        let getURL = "/movie/\(movieID)/credits?api_key=\(api_key)"
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(Credits.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    static func movieReviews(page:Int, movieID:Int, completion: @escaping (ReviewRes)->()) {
        
        let getURL = "/movie/\(movieID)/reviews?api_key=\(api_key)&language=\(language)&page=\(page)"
        
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
                
                let results = try JSONDecoder().decode(ReviewRes.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    
    static func personDetails(personID:Int, completion: @escaping (Person)->()) {
        
        let getURL = "/person/\(personID)?api_key=\(api_key)&language=\(language)"
        
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {

                let results = try JSONDecoder().decode(Person.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    static func personMovieCredits(personID:Int, completion: @escaping (PersonCredits)->()) {
        
        let getURL = "/person/\(personID)/movie_credits?api_key=\(api_key)&language=\(language)"
        
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
        
                let results = try JSONDecoder().decode(PersonCredits.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    
    static func searchMovie(page:Int,query:String, completion: @escaping (MovieResults)->()) {
        
        let getURL = "/search/movie?api_key=\(api_key)&language=\(language)&query=\(query)&page=\(page)&include_adult=false"
        
        MovieAPI.getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(MovieResults.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    
    
    
    
//    static func thumbnailURL(movie: MovieInfo) -> URL? {
//        guard let path = movie.poster_path else{ return nil }
//        if let url = URL(string: MovieAPI.smallImagePath + path) {
//            return url
//        }
//        return nil
//    }
    
//    static func movieCoverUrl(movie: MovieInfo) -> URL? {
//        guard let path = movie.poster_path else{ return nil }
//        if let url = URL(string: MovieAPI.bigImagePath + path) {
//            return url
//        }
//        return nil
//    }
    
//    static func castImageURL(cast: Cast) -> URL? {
//        guard let path = cast.profile_path else{ return nil }
//        if let url = URL(string: MovieAPI.smallImagePath + path) {
//            return url
//        }
//        return nil
//    }
    
//    static func crewImageURL(crew: Crew) -> URL? {
//        guard let path = crew.profile_path else{ return nil }
//        if let url = URL(string: MovieAPI.smallImagePath + path) {
//            return url
//        }
//        return nil
//    }
    
//    static func movieListImageURL(path:String)->URL?{
//        if let url = URL(string: MovieAPI.smallImagePath+path){
//            return url
//        }
//        return nil
//    }
//
    
    static func smallImageURL(path:String)->URL?{
        if let url = URL(string: MovieAPI.smallImagePath+path){
            return url
        }
        return nil
    }
    
    static func bigImageURL(path:String)->URL?{
        if let url = URL(string: MovieAPI.bigImagePath+path){
            return url
        }
        return nil
    }
    
    
    static func youtubeThumb(path:String)->URL?{
        if let url = URL(string: MovieAPI.youtubeThumb+path+"/0.jpg"){
            return url
        }
        return nil
    }

    
    static func youtubeURL(path:String)->URL?{
        if let url = URL(string: MovieAPI.youtubeLink+path){
            return url
        }
        return nil
    }
    
}
