//
//  ConnectionService.swift
//  SmartHomeApp
//
//  Created by Mr. KabachokPuk on 31/12/2017.
//  Copyright © 2017 Andrew Belkov. All rights reserved.
//

import UIKit
import Alamofire

class ConnectionService {

    let ip: String = "192.168.4.1"
    let port: String = "80"
    let timeout: Int = 3 // время ожидания при запросе
    
    private var sessionManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func updateMainLight(turnOn: Bool, bright: Int, success: (() -> Void)? = nil, failure: ((Error?) -> Void)? = nil) {
        
        let parameters = ["turnOn": turnOn, "bright": bright] as [String : Any]
        
        sessionManager.request("http://\(ip):\(port)/mainLight/", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (response) in
            
            print(response)
            
            if let error = response.error {
                failure?(error)
            } else {
                success?()
            }
        }
    }
    
    func updateLED(turnOn: Bool, red: Int, green: Int, blue: Int, success: (() -> Void)? = nil, failure: ((Error?) -> Void)? = nil) {
        
        let parameters = ["turnOn": turnOn, "red": red, "green": green, "blue": blue] as [String : Any]

        sessionManager.request("http://\(ip):\(port)/led/", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (response) in
            
            if let error = response.error {
                failure?(error)
            } else {
                success?()
            }
        }
    }
}
