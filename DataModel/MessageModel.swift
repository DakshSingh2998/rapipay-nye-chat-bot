//
//  MessageModel.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import Foundation
class MessageModel{
    var id = 0
    var sender:[String:Any] = [:]
    var created = ""
    var attachments:[Any] = []
    var sender_username = ""
    var text = ""
    var custom_json:[String:Any] = [:]
    var people:[[String:Any]] = []
    init(data:[String:Any]){
        if let id = data["id"] as? Int{
            self.id = id
        }
        if let sender = data["sender"] as? [String:Any]{
            self.sender = sender
        }
        if let sender = (data["last_message"] as? [String:Any])?["sender"] as? [String:Any]{
            self.sender = sender
        }
        
        if let created = data["created"] as? String{
            self.created = created
        }
        if let created = (data["last_message"] as? [String:Any])? ["created"] as? String{
            self.created = created
        }
        if let attachments = data["attachments"] as? [Any]{
            self.attachments = attachments
        }
        
        
        if let sender_username = data["sender_username"] as? String{
            self.sender_username = sender_username
        }
        if let sender_username = (data["last_message"] as? [String:Any])? ["sender_username"] as? String{
            self.sender_username = sender_username
        }
        if let text = data["text"] as? String{
            self.text = text
        }
        if let text = (data["last_message"] as? [String:Any])? ["text"] as? String{
            self.text = text
        }
        
        if let custom_json = data["custom_json"] as? [String:Any]{
            self.custom_json = custom_json
        }
        if let custom_json = (data["last_message"] as? [String:Any])? ["custom_json"] as? [String:Any]{
            self.custom_json = custom_json
        }
        if let people = data["people"] as? [[String:Any]]{
            self.people = people
        }
    }
}
