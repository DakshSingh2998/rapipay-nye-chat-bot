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
        
        
        ChatApi.shared.sendMessage( chatId: chatModel.id, text: textInTf, completition: {data, error in
            
            guard let data = data as? [String: Any] else {
                completition?((error as! Error).localizedDescription)
                return
            }
            
            completition?(nil)
            
            
        })
    }
    
    
    func typingChange(lastTextInTf:String, textInTf:String, chatModel:ChatModel){
        if(lastTextInTf != textInTf){
            
            ChatApi.shared.sendTyping( chatId: chatModel.id, completition: {_,_ in
            })
        }
        
    }
    func sendTyping(chatModel:ChatModel){
        
        
        ChatApi.shared.sendTyping( chatId: chatModel.id, completition: {_,_ in
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
        
        ChatApi.shared.getMessages( chatId: chatModel.id, completition: {data, error in
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
        ChatApi.shared.patchLastRead( chatId: chatModel.id, lastReadId: lastReadId)
    }
}
