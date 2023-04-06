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
    func getChats(completition: ((Any?, Any?) -> ())?){
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)"
        let httpMethod = "GET"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    func getMessages(chatId:Int, completition: ((Any?, Any?) -> ())?){
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)\(chatId)/\(Constant.shared.getMessages)"
        let httpMethod = "GET"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    
    func createChat(previousOption:String, userToAdd:String,  completition: ((Any, Any) -> ())?){
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)"
        let parameters = "{\n    \"usernames\": [\"\(Common.shared.userDefaultName)\", \"\(userToAdd)\"],\n    \"title\": \"\(previousOption)\",\n    \"is_direct_chat\": true\n}"

        let httpMethod = "PUT"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    
    func sendMessage(chatId:Int, text:String, completition: ((Any, Any) -> ())?){
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)\(chatId)/\(Constant.shared.getMessages)"
        let parameters = "{\n    \"text\": \"\(text)\"}"

        let httpMethod = "POST"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, timeOutInterval: Double.infinity, completition: {data, error in
            completition?(data, error)
            
        })
    }
    func sendTyping(chatId:Int, completition: ((Any?, Any?) -> ())?){
        if(isTyping == true){
            completition?(nil, nil)
            return
        }
        isTyping = true
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)\(chatId)/\(Constant.shared.typing)"

        let httpMethod = "POST"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, timeOutInterval: 2, completition: {data, error in
            self.isTyping = false
            completition?(data, error)
            
            
        })
    }
    func patchLastRead(chatId:Int, lastReadId:Int){
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)\(chatId)/\(Constant.shared.people)"
        let parameters = "{\n    \"last_read\": \(lastReadId)\n}"
        let httpMethod = "PATCH"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(parameters:parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, timeOutInterval: 60, completition: {data, error in
        })
    }
    
    //add member in chat, obsolete as we are now using get or create chat api.
    func addMember(chatId:Int,  userModelToAdd:String, completition:((Any, Any) -> ())?){
        let url = "\(Constant.shared.domain)\(Constant.shared.getChats)\(chatId)/\(Constant.shared.people)"
        let parameters = "{\n    \"username\": \"\(userModelToAdd)\"\n}"

        let httpMethod = "POST"
        let addValue = Common.shared.addHeader(projectId: true, userName: true, userSecret: true)
        let setValue = Common.shared.defaultJson()
        NetworkManager.shared.connect(parameters: parameters, url: url, httpMethod: httpMethod, setValue: setValue, addValue: addValue, completition: {data, error in
            completition?(data, error)
            
        })
    }
    
    
}
