//
//  ApiService.swift
//  DemoSwift
//
//  Created by dungnn on 2/15/17.
//  Copyright © 2017 dungnn. All rights reserved.
//

import Foundation

class ApiService {
    init () {
        
    }
    //typealias MethodHandler1 = (dataResult : String)  -> Void
    static func Get (url : String,callback:@escaping (_ dataResult : Data) -> Void,
                     errorCallBack:@escaping (_ error : Error) -> Void) -> Void {
        //var resultJson : String
        //resultJson = ""
        
        //var message :String  = "demo demo"
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: url)!
        
        //let postString = params
        //let theRequest = NSMutableURLRequest(url: url as URL  )
        //theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //theRequest.httpMethod = "GET"
        //theRequest.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                //resultJson = error!.localizedDescription
                errorCallBack(error!)
            } else {
                //if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {
                if let data = data {
                    //resultJson = result
                    callback(data)
                }
                
            }
            
        })
        
        task.resume()
        
        
        //return resultJson
    }
    static func GetAsync (url : String,callback:@escaping (_ dataResult : SuccessEntity) -> Void,
                     errorCallBack:@escaping (_ error : ErrorEntity) -> Void) -> Void {
        //var resultJson : String
        //resultJson = ""
        
        //var message :String  = "demo demo"
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: url)!
        
        //let postString = params
        //let theRequest = NSMutableURLRequest(url: url as URL  )
        //theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //theRequest.httpMethod = "GET"
        //theRequest.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print("------------------")
                print("------------------")
                print("------------------")
                //message = error!.localizedDescription
                let errorEntity = ErrorEntity()
                errorEntity.error = error!
                errorCallBack(errorEntity)
            } else {
                let re = response as! HTTPURLResponse
                print(re.statusCode)
                
                //if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {
                
                if let data = data {
                    let success = SuccessEntity()
                    success.data = data
                    success.response = response
                    //message = result
                    callback(success)
                }
            }
            
        })
        
        task.resume()
        
        
        //return resultJson
    }
    static func GetAsyncAc (url : String,callback:@escaping (_ dataResult : SuccessEntity) -> Void,errorCallBack:@escaping (_ action : UIAlertController) -> Void) -> Void {
        //var resultJson : String
        //resultJson = ""
        
        //var message :String  = "demo demo"
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: url)!
        
        //let postString = params
        //let theRequest = NSMutableURLRequest(url: url as URL  )
        //theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //theRequest.httpMethod = "GET"
        //theRequest.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
               
                let errorEntity = UIAlertController()
                
                errorCallBack(errorEntity)
            } else {
                
                //if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {
                
                if let data = data {
                    let success = SuccessEntity()
                    success.data = data
                    success.response = response
                    //message = result
                    callback(success)
                }
            }
            
        })
        
        task.resume()
        
        
        //return resultJson
    }
    
    static func PostAsync (url : String, params: String,callback:@escaping (_ dataResult : SuccessEntity) -> Void,
                      errorCallBack:@escaping (_ error : ErrorEntity) -> Void) -> Void {
        //var message :String  = ""
        
        let config = URLSessionConfiguration.default // Session Configuration
        //config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForRequest = 120
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: url)!
        
        let postString = params
        let theRequest = NSMutableURLRequest(url: url as URL)
        theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {
            (data, response, error) in
            if error != nil {
           
                //message = error!.localizedDescription
                let errorEntity = ErrorEntity()
                errorEntity.error = error!
                errorCallBack(errorEntity)
            } else {
                
                //if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {

                if let data = data {
                    let success = SuccessEntity()
                    success.data = data
                    success.response = response
                    //message = result
                    callback(success)
                }
            }
            
        })
        
        task.resume()
    }
    
     static func PostAsyncAc (url : String, params: String,callback:@escaping (_ dataResult : SuccessEntity) -> Void, errorCallBack:@escaping (_ action : UIAlertController) -> Void) -> Void {
        
        let config = URLSessionConfiguration.default // Session Configuration
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: url)!
        let postString = params
        let theRequest = NSMutableURLRequest(url: url as URL)
        theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {
            (data, response, error) in
            if error != nil {
                
                //message = error!.localizedDescription
                let errorEntity = UIAlertController()
              //  errorEntity.error = error!
                errorCallBack(errorEntity)
            } else {
                
                //if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {
                
                if let data = data {
                    let success = SuccessEntity()
                    success.data = data
                    success.response = response
                    //message = result
                    callback(success)
                }
            }
            
        })
        
        task.resume()
    }

    
    static func Post (url : String, params: String,callback:@escaping (_ dataResult : Data) -> Void, errorCallBack:@escaping (_ error : Error) -> Void) -> Void {
        //var message :String  = ""
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: url)!
        
        let postString = params
        let theRequest = NSMutableURLRequest(url: url as URL)
        theRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: theRequest as URLRequest, completionHandler: {
            (data, response, error) in
            if error != nil {
                
                //message = error!.localizedDescription
                errorCallBack(error!)
            } else {
                
                //if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {
                if let data = data {
                    //message = result
                    callback(data)
                }
            }
            
        })
        
        task.resume()
    }
    
    static func Put (url : String, params: String) -> String {
        var result : String
        result = ""
        return result
    }
    
    static func Delete (url : String, params: String) -> String {
        var result : String
        result = ""
        return result
    }
}
