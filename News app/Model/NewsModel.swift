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
    var currentPage : Int = 1
    
    required init?(map: Map) {
        
        super.init(map:  map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        articles <- map["articles"]
        
    }
}



class Articles : Mappable{
    
    var author  : String?
    var title  : String?
    var descriptionss : String?
    var urlToImage : String?
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        author <- map["author"]
        title <- map["title"]
        descriptionss <- map["description"]
        urlToImage <- map["urlToImage"]
    }
}
