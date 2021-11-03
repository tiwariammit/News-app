//
//  Url.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation

enum UrlType : String{
    
    case mock = ""
    case dev = "https://newsapi.org/v2/"
    case release = "asasas"
    case live = "b"
}


struct Urls {
//    
//https://newsapi.org/v2/everything?q=bitcoin&page=2&apiKey=de8ee8412f144e0d914f6fdac9360a87
    
    static let baseUrl = UrlType.dev.rawValue
    
    static let news : String = baseUrl + "everything?q=bitcoin"
    
}
