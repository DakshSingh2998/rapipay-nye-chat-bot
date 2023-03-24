//
//  UserModel.swift
//  Chat
//
//  Created by Daksh on 21/03/23.
//

import Foundation
struct UserModel {
    var id:Int = 0
    var is_authenticated:Bool = false
    var last_message:[String:Any] = [:]
    var userName:String = ""
    var secret:String = ""
    var email:String = ""
    var first_name:String = ""
    var last_name:String = ""
    var avatar:Any = Data()
    var cusom_json:[String:Any] = [:]
    var is_online:Bool = false
    var created:String = ""
    
    init(id: Int, is_authenticated: Bool, last_message: [String : Any], userName: String, secret: String, email: String, first_name: String, last_name: String, avatar: Any, cusom_json: [String : Any], is_online: Bool, created: String) {
        self.id = id
        self.is_authenticated = is_authenticated
        self.last_message = last_message
        self.userName = userName
        self.secret = secret
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.avatar = avatar
        self.cusom_json = cusom_json
        self.is_online = is_online
        self.created = created
    }
    init(data:[String:Any]){
        if let id = data["id"] as? Int{
            self.id = id
        }
        if let is_authenticated = data["is_authenticated"] as? Bool{
            self.is_authenticated = is_authenticated
        }
        if let last_message = data["last_message"] as? [String:Any]{
            self.last_message = last_message
        }
        if let userName = data["username"] as? String{
            self.userName = userName
        }
        if let secret = data["secret"] as? String{
            self.secret = secret
        }
        if let email = data["email"] as? String{
            self.email = email
        }
        if let first_name = data["first_name"] as? String{
            self.first_name = first_name
        }
        if let last_name = data["last_name"] as? String{
            self.last_name = last_name
        }
        if let avatar = data["avatar"]{
            self.avatar = avatar
        }
        if let cusom_json = data["cusom_json"] as? [String:Any]{
            self.cusom_json = cusom_json
        }
        if let is_online = data["is_online"] as? Bool{
            self.is_online = is_online
        }
        if let created = data["created"] as? String{
            self.created = created
        }
        
    }
}
