//
//  LoginModel.swift
//  Chat
//
//  Created by Daksh on 05/04/35.
//

import Foundation
class LoginModel{
    static var shared = LoginModel()
    func getUser(tempUser:String, tempPass:String, completition: ((UserModel?, Error?) -> ())?){
        UserApi.shared.getUser(userName: tempUser, pass: tempPass, completition: { data, error in
            var userModel:UserModel?
            guard let data = data as? [String: Any] else {
                completition?(nil, error as! Error)
                
                return
            }
            if(data["detail"] != nil){
                completition?(nil, nil)
                return
            }
            
            UserDefaults.standard.set(tempPass, forKey: "pass")
            UserDefaults.standard.set(tempUser, forKey: "user")
            Common.shared.userDefaultName = tempUser
            Common.shared.userDefaultPass = tempPass
            userModel = UserModel(data: data)
            completition?(userModel, nil)
        })
         
    }
}
