//
//  ChatMainModel.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import Foundation
class ChatMainModel{
    static var shared = ChatMainModel()
    
    func stringToTime(isoDate:String) -> String{
        if(isoDate == ""){
            return "sending"
        }
          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
          let date = dateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
          let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let convertDateFormatter = DateFormatter()
             convertDateFormatter.dateFormat = "h:mm a"

        return convertDateFormatter.string(from: date)
    }
    func sendMessage(chatModel:ChatModel, textInTf:String, websocket:Websocket, completition: ((String?) -> ())?){
        if(textInTf == ""){
            completition?(nil)
        }
        
        var userName = UserDefaults.standard.value(forKey: "user") as! String
        var pass = UserDefaults.standard.value(forKey: "pass") as! String
        ChatApi.shared.sendMessage(userName: userName, pass: pass, chatId: chatModel.id, text: textInTf, completition: {data, error in
            
            guard let data = data as? [String: Any] else {
                completition?((error as! Error).localizedDescription)
                return
            }
            
            completition?(nil)
            
            
        })
    }
    
    
    func typingChange(lastTextInTf:String, textInTf:String, chatModel:ChatModel){
        if(lastTextInTf != textInTf){
            var userName = UserDefaults.standard.value(forKey: "user") as! String
            var pass = UserDefaults.standard.value(forKey: "pass") as! String
            ChatApi.shared.sendTyping(userName: userName, pass: pass, chatId: chatModel.id, completition: {_,_ in
            })
        }
        
    }
    func sendTyping(chatModel:ChatModel){
        
        var userName = Common.shared.userDefaultName
        var pass = Common.shared.userDefaultPass
        ChatApi.shared.sendTyping(userName: userName, pass: pass, chatId: chatModel.id, completition: {_,_ in
        })
    }
    func setAgentName(chatModel:ChatModel, userModel:UserModel) -> String{
        for i in chatModel.people{
            if((i["person"] as! [String:Any])["username"]as! String != userModel.userName){
                return (i["person"] as! [String:Any])["username"]as! String
            }
        }
        return ""
    }
    func loadMessages(websocket: Websocket, chatModel:ChatModel, completition: ((String?) -> ())?){
        var userName = Common.shared.userDefaultName
        var pass = Common.shared.userDefaultPass
        ChatApi.shared.getMessages(userName: userName, pass: pass, chatId: chatModel.id, completition: {data, error in
            guard let data = data as? [[String: Any]] else {
                if(error != nil){
                    completition?((error as? Error)?.localizedDescription ?? "Api error")
                }
                else{
                    completition?("Api error")
                }
                return
            }
            DispatchQueue.main.async {
                if(data.count != 0){
                    websocket.messages = data.map{
                        MessageModel(data: $0)
                    }
                    self.patchLastRead(chatModel: chatModel, lastReadId: websocket.messages[websocket.messages.count - 1].id)
                }
                websocket.connect(chatModel: chatModel)
            }
            completition?(nil)
            
        })
    }
    func patchLastRead(chatModel:ChatModel, lastReadId: Int){
        ChatApi.shared.patchLastRead(userName: Common.shared.userDefaultName, pass: Common.shared.userDefaultPass, chatId: chatModel.id, lastReadId: lastReadId)
    }
}
