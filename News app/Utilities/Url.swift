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
    
    static let baseUrl = UrlType.dev.rawValue
    
    static let news : String = baseUrl + "everything?q=ios&language=en"
    
}
