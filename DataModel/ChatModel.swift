//
//  ChatModel.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import Foundation
class ChatModel{
    var id = 0
    var admin:[String:Any] = [:]
    var people:[[String: Any]] = []
    var attachments:[Any] = []
    var last_message:[String:Any] = [:]
    var title = ""
    var is_direct_chat = false
    var custom_json:[String:Any] = [:]
    var access_key = ""
    var is_authenticated = true
    var created = ""
    
    init(id: Int = 0, title: String = "", is_direct_chat: Bool = false, access_key: String = "", is_authenticated: Bool = true, created: String = "") {
        self.id = id
        self.title = title
        self.is_direct_chat = is_direct_chat
        self.access_key = access_key
        self.is_authenticated = is_authenticated
        self.created = created
    }
    
    init(data:[String:Any]){
        if let id = data["id"] as? Int{
            self.id = id
        }
        if let admin = data["admin"] as? [String:Any]{
            self.admin = admin
        }
        if let people = data["people"] as? [[String:Any]]{
            self.people = people
        }
        if let attachments = data["attachments"] as? [Any]{
            self.attachments = attachments
        }
        if let last_message = data["last_message"] as? [String:Any]{
            self.last_message = last_message
        }
        if let title = data["title"] as? String{
            self.title = title
        }
        if let is_direct_chat = data["is_direct_chat"] as? Bool{
            self.is_direct_chat = is_direct_chat
        }
        if let custom_json = data["custom_json"] as? [String:Any]{
            self.custom_json = custom_json
        }
        if let access_key = data["access_key"] as? String{
            self.access_key = access_key
        }
        if let is_authenticated = data["is_authenticated"] as? Bool{
            self.is_authenticated = is_authenticated
        }
        
        if let created = data["created"] as? String{
            self.created = created
        }
    }
    
}
