
//
//  APIManager.swift
//  ApiManager
//
//  Created by Amrit Tiwari on 1/3/17.
//  Copyright © 2017 Amrit Inc. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper


public enum RequestType {
    case withoutHeader, withCustomHeader
    //         withHeader,
    //          jsonEncoding, jsonEncodingWithCustomHeader
}

class AlamofireAppManager {
    
    static let session: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
}


struct StatusCode {
    
    static let success : Int = 200
    static let signUpSuccess : Int = 201 // success on sign up
    
    
    //    static let validationError : Int = 205
    //
    //    static let userAlreadyExist : Int = 409 // email already exist
    ////
    //    static let sessionExpired : Int = 403// this is used to know user token is expired comes in errors.
    ////
    //    static let authenticationFailed : Int = 401
    //
    //    static let userNotVerified : Int = 422
    //
    //    static let containNotFound : Int = 404// content not found
}


public class APIManager{
    
    fileprivate var dataRequest: DataRequest!
    
    private var params: [String: AnyObject]?
    private var header : [String : String]?
    
    public init (_ requestType : RequestType, urlString: String, parameters: [String: AnyObject]? = nil, headers: [String: String] = [String:String](), method: Alamofire.HTTPMethod = .post, withEncoding encoding : URLEncoding = URLEncoding.default, isKillAllSession: Bool = false) {
        
        self.params = parameters
        
        let sessionsManager = AlamofireAppManager.session
        sessionsManager.startRequestsImmediately = true
        
        if isKillAllSession {
            sessionsManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            }
        }
        
        switch requestType {
            
        case .withoutHeader:
            
            self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: nil)
            break
            
            
            
        case .withCustomHeader:
            
            self.header = headers
            
            self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            break
            
            
            //        case .jsonEncodingWithCustomHeader:
            //            self.header = headers
            //
            //            self.dataRequest = Alamofire.SessionManager.default.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            
        }
    }
    
    
    func handleResponse<T: BaseResponse>(viewController: UIViewController, forExtraApi: Bool = false, loadingOnView view: UIView, withLoadingColor actColor : UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.00), isShowProgressHud: Bool = true,isShowNoNetBanner: Bool = true, isShowAlertBanner: Bool = true, resignResponder: Bool = true, beforeRequest: (() -> Void)? = nil,completionHandler: @escaping (T)-> Void, errorBlock: ((T)->Void)? = nil,failureBlock: ((String)->Void)? = nil){
        if let beforeRequest = beforeRequest {
            beforeRequest()
        }
        
        var style = ToastManager.shared.style
        style.backgroundColor = .toastError
        style.cornerRadius = 0
        
        do {
            let googleTest = try Reachability(hostname: "www.google.com")
            
            guard let result = googleTest?.isReachable, result else {
                
                let errorMessage = Errors.Apis.noInternet
                failureBlock?(errorMessage)
                
                if isShowNoNetBanner{
                    
                    
                    viewController.view?.makeToast(errorMessage, position: .bottom, title: nil, image: nil, style: style, completion: nil)
                }
                return
            }
            
        } catch {
            print(error)
        }
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let loadingView = LoadingView.init()
        
        if isShowProgressHud {
            
            view.isUserInteractionEnabled = false
            loadingView.set(withLoadingView: view, withBackgroundColor: .loadingWhite, withLoadingIndicatorColor: .app)
        }
        
        self.dataRequest.responseObject { (response: DataResponse<T>) in
            
            if isShowProgressHud{
                DispatchQueue.main.async {
                    view.isUserInteractionEnabled = true
                    loadingView.remove()
                }
            }
            
            if resignResponder{
                view.resignFirstResponder()
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            let headerStatusCode = response.response?.statusCode ?? 0
            print("statusCode:- \(headerStatusCode)")
            
            switch response.result {
            case .success(let successData):
                
                var statusCode = successData.statusCode ?? headerStatusCode
                
                successData.statusCodeFromHeader = headerStatusCode
                
                if forExtraApi{
                    statusCode = headerStatusCode
                }
                
                if statusCode == StatusCode.success || statusCode == StatusCode.signUpSuccess{
                    completionHandler(successData)
                    return
                }
                
                let message = successData.message ?? Errors.Apis.serverError
                errorBlock?(successData)
                
                
            case .failure(let error):
                print(error)
                
                if isShowAlertBanner {
                    if headerStatusCode == 0{
                        let errorMessage = Errors.Apis.noInternet
                        
                        viewController.presentErrorDialog(errorMessage)
                        failureBlock?(errorMessage)
                        
                        return()
                    }
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
           
                
                let errorMessage = ErrorPredictor.get(errorFromAlamofire: error)
                failureBlock?(errorMessage)
                
                if isShowAlertBanner {
                    viewController.presentErrorDialog(errorMessage)
                    //                    appDelegate.presentErrorDialog(errorMessage, viewContoller: viewController)
                }
            }
        }
        
        //delete
        self.dataRequest.responseJSON { (response) in
            
            print(response.data ?? "No data")
            print(response.timeline)
            print(response.request ?? "No request")
            print("Parameter:- \(String(describing: self.params))")
            print("Headers:-\(String(describing: self.header))")
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let val):
                print(val)
            }
        }
    }
    
    
    func handleResponseForResponseJSON(viewController: UIViewController, loadingOnView view: UIView,withLoadingColor actColor: UIColor = .white,isShowProgressHud: Bool = true,isShowNoNetBanner: Bool = true, isShowAlertBanner: Bool = true,completionHandler: @escaping (Any)-> Void, errorBlock: ((String)->Void)? = nil,failureBlock: ((String)->Void)? = nil){
        
        do {
            let googleTest = try Reachability(hostname: "www.google.com")
            
            guard let result = googleTest?.isReachable, result else {
                
                failureBlock?(Errors.Apis.noInternet)
                
                if isShowNoNetBanner{
                    viewController.presentErrorDialog( Errors.Apis.noInternet)
                }
                return
            }
            
        } catch {
            print(error)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let loadingView = LoadingView.init()//get()
        
        if isShowProgressHud {
            
            view.isUserInteractionEnabled = false
            loadingView.set(withLoadingView: view, withBackgroundColor: .loadingWhite, withLoadingIndicatorColor: .app)
            //            view.addSubview(loadingView)
        }
        
        self.dataRequest.responseJSON { (response) in
            
            if isShowProgressHud{
                
                DispatchQueue.main.async {
                    view.isUserInteractionEnabled = true
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    loadingView.remove()
                }
            }
            
            
            let statusCode = response.response?.statusCode ?? 0
            print("statusCode:- \(statusCode)")
            
            switch response.result{
            case .success(let value):
                
                if statusCode == StatusCode.success || statusCode == StatusCode.signUpSuccess {
                    completionHandler(value)
                    return
                }
                
                errorBlock?(Errors.Apis.serverError)
                if isShowNoNetBanner{
                    viewController.presentErrorDialog( Errors.Apis.serverError)
                }
                
                
            case .failure(let error):
                print(error)
                let errorMessage = ErrorPredictor.get(errorFromAlamofire: error)
                
                if isShowAlertBanner {
                    viewController.presentErrorDialog(errorMessage)
                }
                failureBlock?(errorMessage)
                //                }
            }
        }
        
        //delete
        self.dataRequest.responseJSON { (response) in
            
            //            print(response.data ?? "No data")
            //            print(response.timeline)
            print(response.request ?? "No request")
            print(self.params ?? "No Params")
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let val):
                print(val)
            }
        }
    }
    
}




class ErrorPredictor{
    class func get( errorFromAlamofire : Error) -> String{
        
        if let error = errorFromAlamofire as? AFError {
            
            switch error {
            case .invalidURL(let url):
                let errorMessage = "Invalid URL: \(url) - \(error.localizedDescription)"
                return errorMessage
                
            case .parameterEncodingFailed(let reason):
                //                let errorMessage = "Parameter encoding failed: \(error.localizedDescription)"
                print("Failure Reason: \(reason)")
                let errorMessage = "Parameter encoding failed: \(reason)"
                return errorMessage
                
            case .multipartEncodingFailed(let reason):
                //                let errorMessage = "Multipart encoding failed: \(error.localizedDescription)"
                print("Failure Reason: \(reason)")
                let errorMessage = "Multipart encoding failed: \(reason)"
                return errorMessage
                
            case .responseValidationFailed(let reason):
                //                let errorMessage = "Response validation failed: \(error.localizedDescription)"
                print("Failure Reason: \(reason)")
                var errorMessage = "Response validation failed: \(reason)"
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    errorMessage = "Downloaded file could not be read"
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    errorMessage = "Content Type Missing: \(acceptableContentTypes)"
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    errorMessage = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                    errorMessage = "Response status code was unacceptable: \(code)"
                }
                return errorMessage
                
            case .responseSerializationFailed(let reason):
                //                let errorMessage = "Response serialization failed: \(error.localizedDescription)"
                print("Failure Reason: \(reason)")
                let errorMessage = "Response serialization failed: \(reason)"
                return errorMessage
            }
            
        } else if let error = errorFromAlamofire as? URLError {
            if error.code == .notConnectedToInternet{
                
                return errorFromAlamofire.localizedDescription
            }
            //URLError occurred:
            let errorMessage = "\(error.localizedDescription)"
            return errorMessage
            
        } else {
            let errorMessage = "Internal Server Error"//\(errorFromAlamofire.localizedDescription)"
            return errorMessage
        }
    }
}


