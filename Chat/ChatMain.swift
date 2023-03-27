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
    @State var alertText = ""
    @State var showAlert = false
    @FocusState var textInTfFocused:Bool
    @ObservedObject var websocket = Websocket()
    @State var timer:Timer?
    @State var lastTextInTf = ""
    @State var tfWidth = Common.shared.width - 100
    @State var height = Common.shared.height
    @State var width = Common.shared.width
    @State var isTextIncorrect = false
    @ObservedObject var textInTf = TextModel()

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
                generateList()
                
                Spacer()
                
                ZStack(alignment: .leading){
                    HStack{
                        Spacer()
                        Image(systemName: "arrowtriangle.right.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .foregroundColor(Color("Blue"))
                            .frame(alignment: .trailing)
                            .padding(.trailing, 16)
                        
                    }
                    .frame(maxWidth: .infinity)
                    CustomTextField(defaultplaceholder: "Message", vm: textInTf, width: $tfWidth, isInCorrect: $isTextIncorrect, commitClosure: {
                        sendMessage()
                    })
                    .focused($textInTfFocused)
                    .padding(.leading, 16)
                    
                    
                }
                .frame(maxWidth: .infinity)
                    
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
                    typingChange()
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
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)){_ in
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                self.width = Common.shared.width
                if(Common.shared.currentOrientation == .portrait ){
                    self.tfWidth = Common.shared.width - 100
                }
                else{
                    self.tfWidth = Common.shared.width - 200
                }
                
                self.height = Common.shared.height
            }
        }
    }
    func typingChange(){
        if(lastTextInTf != textInTf.value){
            var userName = UserDefaults.standard.value(forKey: "user") as! String
            var pass = UserDefaults.standard.value(forKey: "pass") as! String
            ChatApi.shared.sendTyping(userName: userName, pass: pass, chatId: chatModel!.id, completition: {_,_ in
            })
        }
        lastTextInTf = textInTf.value
    }
    func sendMessage(){
        var userName = UserDefaults.standard.value(forKey: "user") as! String
        var pass = UserDefaults.standard.value(forKey: "pass") as! String
        ChatApi.shared.sendMessage(userName: userName, pass: pass, chatId: chatModel!.id, text: textInTf.value, completition: {data, error in
            guard let data = data as? [String: Any] else {
                alertText = (error as! Error).localizedDescription
                showAlert = true
                return
            }
            textInTf.value = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                textInTfFocused = true
            })
            
        })
    }
    func generateList() -> some View{
        return List(0..<websocket.messages.count, id: \.self){ idx in
            VStack{
                if(websocket.messages[idx].sender_username == userModel?.userName){
                    
                    HStack(alignment: .top, spacing: -4){
                        Spacer(minLength: 64)
                        ChatCell(messageModel: websocket.messages[idx])
                        
                            .upperCurve(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                        Image(systemName: "arrowtriangle.forward.fill")
                            .foregroundColor(Color("LightGrey"))
                            .padding(.top, -1)
                    }
                }
                else{
                    HStack(alignment: .top, spacing: -4){
                        Image(systemName: "arrowtriangle.backward.fill")
                            .foregroundColor(Color("LightGrey"))
                            .padding(.top, -1)
                        ChatCell(messageModel: websocket.messages[idx])
                            .upperCurve(10, corners: [.topRight, .bottomLeft, .bottomRight])
                        Spacer(minLength: 64)
                    }
                    
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }.listStyle(.plain)
            .padding(.horizontal, -20)
    }
}

/*
struct ChatMain_Previews: PreviewProvider {
    static var previews: some View {
        ChatMain()
    }
}

*/
