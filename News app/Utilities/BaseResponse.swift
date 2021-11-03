//
//  AllResponse.swift
//
//  Created by Amrit Tiwari on 1/3/17.
//  Copyright © 2017 Amrit Inc. All rights reserved.


import Foundation
import ObjectMapper

protocol MappableExtended: Mappable{
   
    var statusCodeFromHeader: Int? {get}
    var message: String? {get}
    var statusCode : Int?{ get }
    var status : String?{ get }
    
    var totalResults : Int?{get}

    
}

class BaseResponse: MappableExtended {
    
    private var _message: String?
    private var _status : String?
    
    private var _statusCode : Int?

    private var _totalResults: Int?

    public var message: String? {
        get {
            return _message
        }
    }
    
    public var status: String?{
        get{
            return _status
        }
    }

    
    public var statusCode: Int?{
        get{
            return _statusCode
        }
    }
    
    public var totalResults: Int?{
        get{
            return _totalResults
        }
    }
    
    public var statusCodeFromHeader: Int?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        _status <- map["status"]
        
        if _message == nil{
            _message  <- map["message"]
        }
        
        _totalResults <- map["totalResults"]
        
        if _status == nil{
            var code : Int?
            code <- map["code"]
        }
        
        if _message == nil{
            _message  <- map["error_message"]            
        }
    }
}
