//
//  UserApi.swift
//  Chat
//
//  Created by Daksh on 03/04/35.
//

import Foundation
class UserApi{
    static var shared = UserApi()
    
    func createUser(userName:String, firstName:String, lastName:String, password:String, completition: ((Any, Any)->())?){
        let parameters = "{\n    \"username\": \"\(userName)\",\n    \"first_name\": \"\(firstName)\",\n    \"last_name\": \"\(lastName)\",\n    \"secret\": \"\(password)\" \n}"
        let url = "https://api.chatengine.io/users/"
        let httpMethod = "POST"
        let addValue = ["PRIVATE-KEY" : Common.shared.privateKey]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, err in
            completition?(data, err)
        })
        
    }
    func getUser(userName:String, pass:String, completition: ((Any, Any) -> ())?){
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        let httpMethod = "GET"
        let url = "https://api.chatengine.io/users/me/"
        
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, err in
            completition?(data, err)
        })
    }
    func getUsers(completition: ((Any, Any) -> ())?){
        let addValue = ["PRIVATE-KEY" : Common.shared.privateKey]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        let httpMethod = "GET"
        let url = "https://api.chatengine.io/users/"
        
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, err in
            completition?(data, err)
        })
    }
    
    
}
