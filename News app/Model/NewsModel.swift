//
//  NewsModel.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation
import ObjectMapper


class NewsModel : BaseResponse{
    
    var articles : [Articles]?
    var currentPage : Int = 1 //initially page is always 1 so
    var nextPage : Int = 2// this is to fetch the new data so i have made 1 greater then current page initially
    var isDatafectching = false // used to pagination data
    
    var totalResults : Int?
    
    required init?(map: Map) {
        
        super.init(map:  map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        articles <- map["articles"]
        totalResults <- map["totalResults"]
        
    }
}



class Articles : Mappable{
    
    var author  : String?
    var title  : String?
    var descriptionss : String?
    var urlToImage : String?
    var publishedAt : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        author <- map["author"]
        title <- map["title"]
        descriptionss <- map["description"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]

    }
}
