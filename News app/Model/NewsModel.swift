//
//  NewsModel.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation


class NewsModel : Decodable{
    
    var articles : [Articles]?
    var currentPage : Int = 1 //initially page is always 1 so
    var nextPage : Int = 2// this is to fetch the new data so i have made 1 greater then current page initially
    var isDatafectching = false // used to pagination data
    
    var totalResults : Int?
    
    private enum CodingKeys: String, CodingKey { case articles } //this is usually synthesized, but we have to define it ourselves to exclude our additional variable

    
}




class Articles : Decodable{
    
    var author  : String?
    var title  : String?
    var descriptionss : String?
    var urlToImage : String?
    var publishedAt : String?
  
}
