//
//  MockData.swift
//  News appTests
//
//  Created by Amrit Tiwari on 04/11/2021.
//

import Foundation
import XCTest
import ObjectMapper
@testable import News_app

class MockData {
    func stubNewsResult() -> NewsModel? {
        guard let data = FetchedNewsTest.get("source") else {
            XCTAssert(false, "Can't get data from source.json")
            return nil
        }
        
        return data
    }
}



