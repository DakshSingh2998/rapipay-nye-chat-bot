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
            //self.didLoad = true
        }
        guard var url = URL(string: "wss://api.chatengine.io/chat/?projectID=\(Common.shared.projectId)&chatID=\(chatModel!.id)&accessKey=\(chatModel!.access_key)") else { return }
       
        
        let request = URLRequest(url: url)
        self.webSocketTask = URLSession.shared.webSocketTask(with: request)
        
        webSocketTask?.resume()
        receiveMessage()
        self.pingTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            self.ping()
            })
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
                    if(data2["action"] as! String == "new_message"){
                        guard let data2 = data2["data"] as? [String:Any] else{
                            break
                        }
                        guard let data2 = data2["message"] as? [String:Any] else{
                            break
                        }
                        var msgModel = MessageModel(data: data2)
                        if(msgModel.sender_username != Common.shared.userDefaultName){
                            DispatchQueue.main.sync {
                                self.messages.append(msgModel)
                            }
                        }
                        else{
                            for i in (0..<self.messages.count).reversed(){
                                if(self.messages[i].text == msgModel.text){
                                    self.messages[i] = msgModel
                                    break
                                }
                            }
                        }
                        
                    }
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
    
    func ping() {
        webSocketTask!.sendPing { (error) in
            if let error = error {
                print("Ping failed: \(error)")
            }
        }
    }
    
    
}





