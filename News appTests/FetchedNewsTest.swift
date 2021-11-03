//
//  FetchedNewsTest.swift
//  News appTests
//
//  Created by Amrit Tiwari on 04/11/2021.
//

import Foundation
import XCTest
import ObjectMapper
@testable import News_app


class FetchedNewsTest : NSObject{
    
    class func get(_ fileName: String)-> NewsModel?{
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                
                let text = try String(contentsOfFile: path, encoding: .utf8)
                
                let dict = try JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                
                let data = Mapper<NewsModel>().map(JSON: dict)
                
                return data
                
            } catch let error {
                
                XCTFail("parse error: \(error.localizedDescription)")
            }
        } else {
            
            XCTFail("Invalid filename/path.")
        }
        return nil
    }
}
