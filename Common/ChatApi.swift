//
//  ChatApi.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import Foundation
class ChatApi{
    static var shared = ChatApi()
    var isTyping = false
    func getChats(userName:String, pass:String, completition: ((Any?, Any?) -> ())?){
        let url = "https://api.chatengine.io/chats/"
        let httpMethod = "GET"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    func getMessages(userName:String, pass:String, chatId:Int, completition: ((Any?, Any?) -> ())?){
        let url = "https://api.chatengine.io/chats/\(chatId)/messages/"
        let httpMethod = "GET"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    
    func createChat(userName:String, pass:String, previousOption:String, userToAdd:String,  completition: ((Any, Any) -> ())?){
        let url = "https://api.chatengine.io/chats/"
        let parameters = "{\n    \"usernames\": [\"\(userName)\", \"\(userToAdd)\"],\n    \"title\": \"\(previousOption)\",\n    \"is_direct_chat\": true\n}"

        let httpMethod = "PUT"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    
    func sendMessage(userName:String, pass:String, chatId:Int, text:String, completition: ((Any, Any) -> ())?){
        let url = "https://api.chatengine.io/chats/\(chatId)/messages/"
        let parameters = "{\n    \"text\": \"\(text)\"}"

        let httpMethod = "POST"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, timeOutInterval: Double.infinity, completition: {data, error in
            completition?(data, error)
            
        })
    }
    func sendTyping(userName:String, pass:String, chatId:Int, completition: ((Any?, Any?) -> ())?){
        if(isTyping == true){
            completition?(nil, nil)
            return
        }
        isTyping = true
        let url = "https://api.chatengine.io/chats/\(chatId)/typing/"

        let httpMethod = "POST"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager().connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, timeOutInterval: 2, completition: {data, error in
            completition?(data, error)
            self.isTyping = false
            
        })
    }
    func patchLastRead(userName:String, pass:String, chatId:Int, lastReadId:Int){
        let url = "https://api.chatengine.io/chats/\(chatId)/people/"
        let parameters = "{\n    \"last_read\": \(lastReadId)\n}"
        let httpMethod = "PATCH"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager().connect(parameters:parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, timeOutInterval: 60, completition: {data, error in            
        })
    }
    
    func addMember(chatId:Int, userName:String, pass:String, userModelToAdd:String, completition:((Any, Any) -> ())?){
        let url = "https://api.chatengine.io/chats/\(chatId)/people/"
        let parameters = "{\n    \"username\": \"\(userModelToAdd)\"\n}"

        let httpMethod = "POST"
        let addValue = ["Project-ID" : Common.shared.projectId, "User-Name" : userName, "User-Secret" : pass]
        let setValue = ["Content-Type" : "application/json", "Accept" : "application/json"]
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    
    
}
