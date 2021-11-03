//
//  News_appTests.swift
//  News appTests
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import XCTest
@testable import News_app
import ObjectMapper

class News_appTests: XCTestCase {
    
    func testMapsData1() {
        
        let jsonDictionary: [String: Any] = [
            "author": "noreply@blogger.com (Unknown)",
            "title" : "Google to give Iphone users a better experience of it's app, here's how",
            "description": "﻿\r\nGoogle has never really given ‘inferior’ treatment to iPhone users when it comes to its apps and services. Some app features, in fact, get to iPhone users first before Android smartphone users. Having said that, the Google experience on iPhone can be bette…",
            "urlToImage": "https://blogger.googleusercontent.com/img/a/AVvXsEg8cc1GIT41k9hux9FsbxmmQP_Tz6PzFOfTRhFcGy0L3kbQBlsiBqWBQ8Wn5AJVgZFSL-zvN6fX7tIAp5WpRIrV6bhsfuehrQ99LmnXV7gHK1N_2r90Y1aCGobMk40QrZW7Dq_DkEMAGzHfmaa26zA_7KtwzyqXpNryG9t_IIzv9X9J9o4FF8Mf4QR3UQ=w1200-h630-p-k-no-nu",
            
            "publishedAt": "2021-10-11T08:07:00Z"
        ]
        
        let jsonMain : [String : Any] = ["articles" : [jsonDictionary], "status": "ok", "totalResults": 11387]
        
        if let model = Mapper<NewsModel>().map(JSON: jsonMain), let articles = model.articles{
            
            XCTAssertEqual(articles[0].title, "Google to give Iphone users a better experience of it's app, here's how")
            
            XCTAssertEqual(articles[0].urlToImage, "https://blogger.googleusercontent.com/img/a/AVvXsEg8cc1GIT41k9hux9FsbxmmQP_Tz6PzFOfTRhFcGy0L3kbQBlsiBqWBQ8Wn5AJVgZFSL-zvN6fX7tIAp5WpRIrV6bhsfuehrQ99LmnXV7gHK1N_2r90Y1aCGobMk40QrZW7Dq_DkEMAGzHfmaa26zA_7KtwzyqXpNryG9t_IIzv9X9J9o4FF8Mf4QR3UQ=w1200-h630-p-k-no-nu")
            
            
            XCTAssertEqual(articles[0].publishedAt, "2021-10-11T08:07:00Z")
        }
    }
    
    func testMapsData(){
        guard let data = FetchedNewsTest.get("Source") else {
            XCTAssert(false, "Can't get data from source.json")
            return
        }
        
        XCTAssertEqual(data.articles?[1].title, "Twitter's Spaces Spark Program will pay creators to broadcast live audio")

    }

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
