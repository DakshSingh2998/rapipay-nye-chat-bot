//
//  WebSocket.swift
//  Chat
//
//  Created by Daksh on 21/03/23.
//

import Foundation
import SwiftUI
class Websocket:ObservableObject {
    @Published var messages:[MessageModel] = []
     var webSocketTask:URLSessionWebSocketTask?
    @Published var userTyping = ""
    @Published var lastTyping = ""
    @Published var time = DispatchTime.now()
    @Published var chatModel = ChatModel(data: [:])
     var pingTimer:Timer?
    @Published var didLoad = false
    @Published var chatId:Int?
    @Published var accessKey:String?
    
    func connect(chatModel:ChatModel?) {
        if(didLoad == false){
            DispatchQueue.main.async {
                self.chatModel = chatModel!
            }
        }
        guard var url = URL(string: "wss://api.chatengine.io/chat/?projectID=\(Common.shared.projectId)&chatID=\(chatModel!.id)&accessKey=\(chatModel!.access_key)") else { return }
       
        
        let request = URLRequest(url: url)
        self.webSocketTask = URLSession.shared.webSocketTask(with: request)
        
        webSocketTask?.resume()
        receiveMessage()
        
    }
    func connect2() {
        guard let url = URL(string: "wss://api.chatengine.io/person/?publicKey=\(Common.shared.projectId)&username=\(Common.shared.userDefaultName)&secret=\(Common.shared.userDefaultPass)") else { return }
        let request = URLRequest(url: url)
        self.webSocketTask = URLSession.shared.webSocketTask(with: request)
        
        webSocketTask?.resume()
        receiveMessage()
    }
    
    
    
    private func receiveMessage() {
        webSocketTask?.receive { result in
            self.receiveMessage()
            //print(result)
            switch result {
            case .failure(let error):
                //print("rrr", error.localizedDescription)
                self.connect(chatModel: self.chatModel)
                return
                //self.webSocketTask?.resume()
            case .success(let message):
                switch message {
                case .string(let text):
                    //print(text)
                    guard let data = text.data(using: .utf8) else{
                        break
                    }
                    guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else{
                            print("SERL ERR")
                            break
                    }
                    
                    guard let data2 = jsonData as? [String:Any] else{
                        break
                    }
                    
                    // here we are checking if id last message from another user is grater than last present last read id  then call patch lastread api to update last read
                    if(data2["action"] as! String == "edit_chat"){
                        guard let data2 = data2["data"] as? [String:Any] else{
                            break
                        }
                        guard let last_message = data2["last_message"] as? [String:Any] else{
                            return
                        }
                        
                        //chatmodel is old chatmodelm newchatmodel is latest chatmodel that arrived in this websocket
                        
                        var people = self.chatModel.people
                        var newChatModel = ChatModel(data: data2)
                        var newPeople = newChatModel.people
                        
                        
                        //matching last read read of old and new chatmodel
                        for i in 0..<people.count{
                            var person = UserModel(data: people[i]["person"] as! [String : Any])
                            for j in 0..<newPeople.count{
                                var newPerson = UserModel(data: newPeople[i]["person"] as! [String : Any])
                                if(newPerson.userName != Common.shared.userDefaultName){
                                    continue
                                }
                                if((people[i]["last_read"] as? Int ?? -1) < newPeople[j]["last_read"] as? Int ?? 0){
                                    ChatApi.shared.patchLastRead(chatId: self.chatModel.id, lastReadId: last_message["id"] as! Int)
                                    break
                                }
                            }
                            
                            
                            
                        }
                        DispatchQueue.main.async {
                            self.chatModel = newChatModel
                        }
                    }
                    
                    // if its a new message then append it in list and, if same message is sent by user than find that message object in list and replace it with new one from server
                    if(data2["action"] as! String == "new_message"){
                        guard let data2 = data2["data"] as? [String:Any] else{
                            break
                        }
                        guard let data2 = data2["message"] as? [String:Any] else{
                            break
                        }
                        var msgModel = MessageModel(data: data2)
                        if(msgModel.sender_username != Common.shared.userDefaultName){
                            DispatchQueue.main.async {
                                self.messages.append(msgModel)
                            }
                        }
                        else{
                            
                            for i in (0..<self.messages.count).reversed(){
                                if(self.messages[i].text == msgModel.text && (i == 0 || self.messages[i - 1 ].created != "" )){
                                    DispatchQueue.main.async {
                                        self.messages[i] = msgModel
                                    }
                                    
                                    break
                                }
                            }
                        }
                        
                    }
                    
                    //handling typing event here, using two strings user typing is string to show on ui if both the user or multiple users are typing then show both typing, last typing variable is used to store name of last user typing.
                    if(data2["action"] as! String == "is_typing"){
                        guard let data2 = data2["data"] as? [String:Any] else{
                            break
                        }
                        DispatchQueue.main.async {
                            if(self.userTyping != "" &&  self.lastTyping != data2["person"] as! String){
                                self.userTyping = "Both"
                            }
                            else{
                                self.userTyping = data2["person"] as! String
                            }
                            self.lastTyping = data2["person"] as! String
                            
                            self.time = .now() + 2
                        }
                        
                    }
                    
                    
                case .data(let data):
                    // Handle binary data
                    break
                @unknown default:
                    break
                }
            }
            
            
        }
    }

    func disconnectt(){
        webSocketTask?.cancel()
    }
    
    
}





