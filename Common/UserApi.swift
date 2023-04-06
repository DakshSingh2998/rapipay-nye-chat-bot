//
//  UserApi.swift
//  Chat
//
//  Created by Daksh on 03/04/35.
//

import Foundation
class UserApi{
    
    func createUser(userName:String, firstName:String, lastName:String, password:String, completition: ((Any, Any)->())?){
        let parameters = "{\n    \"username\": \"\(userName)\",\n    \"first_name\": \"\(firstName)\",\n    \"last_name\": \"\(lastName)\",\n    \"secret\": \"\(password)\" \n}"
        let url = "\(Constant.shared.domain)\(Constant.shared.createUser)"
        let httpMethod = "POST"
        let addValue = Common.shared.addHeader(privateKey: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, err in
            completition?(data, err)
        })
        
    }
    func getUser(userName:String, pass:String, completition: ((Any, Any) -> ())?){
        var addValue = Common.shared.addHeader(projectId: true)
        addValue["User-Name"] = userName
        addValue["User-Secret"] = pass
        let setValue = Common.shared.defaultJson()
        let httpMethod = "GET"
        let url = "\(Constant.shared.domain)\(Constant.shared.myUser)"
        
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, err in
            completition?(data, err)
        })
    }
    func getUsers(completition: ((Any, Any) -> ())?){
        let addValue = ["PRIVATE-KEY" : Common.shared.privateKey]
        let setValue = Common.shared.defaultJson()
        let httpMethod = "GET"
        let url = "\(Constant.shared.domain)\(Constant.shared.createUser)"
        
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, err in
            completition?(data, err)
        })
    }
    
    
}
