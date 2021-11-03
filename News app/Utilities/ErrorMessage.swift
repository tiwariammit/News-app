//
//  ErrorMessage.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation

struct ErrorMessage {
    
        static let noContentAvailable = "No content available"
    
}


struct Errors {
    struct Validation {

        static let error = "Error!"
        static let success = "Success!"
        static let warning = "Warning!"
    }
    
    
    struct Apis {
        
        static let noInternet = "The Internet connection appears Offline."
        static let error = "Error"
        static let serverError = "Server Error. Try again"
        
        static let tokenExpired = "Login Token Expired! Login Again."
        
    }
}
