//
//  NetworkManager.swift
//  Chat
//
//  Created by Daksh on 20/03/23.
//

import Foundation
import SwiftUI

struct NetworkManager{
    static var shared = NetworkManager()
    
    func connect(parameters:String = "", url:String, httpMethod:String, setValue:[String:String], addValue:[String:String], completition: ((Any, Any) -> ())?){
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: TimeInterval(60))
        for i in Array(setValue.keys){
            request.setValue(setValue[i], forHTTPHeaderField: i)
        }
        for i in Array(addValue.keys){
            request.setValue(addValue[i], forHTTPHeaderField: i)
        }
        request.httpMethod = httpMethod
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completition?(data, error)
                return
            }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else{
                print("SERL ERR")
                return
            }
            completition?(jsonData, error)
        }
        task.resume()
    }
}
