//
//  ChatMain.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import SwiftUI

struct ChatMain: View {
    @Binding var ONPAGE:Double
    @Binding var userModel:UserModel?
    @Binding var chatModel:ChatModel?
    @State var textInTf = ""
    @State var alertText = ""
    @State var showAlert = false
    @FocusState var textInTfFocused:Bool
    @ObservedObject var websocket = Websocket()
    @State var timer:Timer?
    @State var lastTextInTf = ""

    var body: some View {
        ZStack{
            VStack{
                Text(websocket.userTyping)
                    .onChange(of: websocket.time, perform: {newVal in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            if(websocket.time <= .now()){
                                websocket.userTyping = ""
                                websocket.lastTyping = ""
                            }
                        })
                        
                    })
                List(0..<websocket.messages.count, id: \.self){ idx in
                    VStack{
                        if(websocket.messages[idx].sender_username == userModel?.userName){
                            
                            HStack{
                                Spacer(minLength: 64)
                                ChatCell(messageModel: websocket.messages[idx])
                            }
                        }
                        else{
                            HStack{
                                ChatCell(messageModel: websocket.messages[idx])
                                Spacer(minLength: 64)
                            }
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                }.listStyle(.plain)
                    .padding(.horizontal, -20)
                
                Spacer()
                TextField("Enter :)", text: $textInTf, onCommit: {
                    sendMessage()
                })
                .focused($textInTfFocused)
                
                    
            }
        }
        .alert(alertText, isPresented: $showAlert, actions: {
            Button("OK", role: .cancel, action: {
                showAlert = false
            })
        })
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                        updateCounting()
                    })
            })
            
             
            var userName = UserDefaults.standard.value(forKey: "user") as! String
            var pass = UserDefaults.standard.value(forKey: "pass") as! String
            
            ChatApi.shared.getMessages(userName: userName, pass: pass, chatId: chatModel!.id, completition: {data, error in
                guard let data = data as? [[String: Any]] else {
                    alertText = (error as! Error).localizedDescription
                    showAlert = true
                    return
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    websocket.messages = data.map{
                        MessageModel(data: $0)
                    }
                    websocket.connect(chatModel: chatModel)
                    
                }
                
            })
             
            
            
        }
    }
    func updateCounting(){
        if(lastTextInTf != textInTf){
            var userName = UserDefaults.standard.value(forKey: "user") as! String
            var pass = UserDefaults.standard.value(forKey: "pass") as! String
            ChatApi.shared.sendTyping(userName: userName, pass: pass, chatId: chatModel!.id, completition: {_,_ in
            })
        }
        lastTextInTf = textInTf
    }
    func sendMessage(){
        var userName = UserDefaults.standard.value(forKey: "user") as! String
        var pass = UserDefaults.standard.value(forKey: "pass") as! String
        ChatApi.shared.sendMessage(userName: userName, pass: pass, chatId: chatModel!.id, text: textInTf, completition: {data, error in
            guard let data = data as? [String: Any] else {
                alertText = (error as! Error).localizedDescription
                showAlert = true
                return
            }
            textInTf = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                textInTfFocused = true
            })
            
        })
    }
}

/*
struct ChatMain_Previews: PreviewProvider {
    static var previews: some View {
        ChatMain()
    }
}

*/
