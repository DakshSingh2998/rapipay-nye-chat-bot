//
//  ChatMain.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import SwiftUI

struct ChatMain: View {
    @Environment(\.dismiss) var dismiss

    @Binding var ONPAGE:Double
    @Binding var userModel:UserModel?
    @Binding var chatModel:ChatModel?
    @State var alertText = ""
    @State var showAlert = false
    @FocusState var textInTfFocused:Bool
    @ObservedObject var websocket = Websocket()
    @State var timer:Timer?
    @State var lastTextInTf = ""
    @State var tfWidth = Common.shared.width - (Common.shared.currentOrientation == .portrait ? 100 : 100)
    @State var height = Common.shared.height
    @State var width = Common.shared.width
    @State var isTextIncorrect = false
    @ObservedObject var textInTf = TextModel()
    @State var agentName = ""
    @State var message_queue:[String] = []
    var body: some View {
            VStack(spacing: 0){
                EmptyView()
                upperUi()
                
                generateList()
                Spacer()
                
                bottomUi()
        }
            .navigationTitle(chatModel?.title ?? "Customer Care")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("LogOut"){
                        UserDefaults.standard.removeObject(forKey: "pass")
                        UserDefaults.standard.removeObject(forKey: "user")
                        
                        ONPAGE = 1.0
                    }
                })
            })
            
        
        .alert(alertText, isPresented: $showAlert, actions: {
            Button("OK", role: .cancel, action: {
                showAlert = false
            })
        })
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                textInTfFocused = true
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    ChatMainModel().typingChange(lastTextInTf: lastTextInTf, textInTf: textInTf.value, chatModel: chatModel!)
                    lastTextInTf = textInTf.value
                    })
            })
            agentName = ChatMainModel.shared.setAgentName(chatModel: chatModel!, userModel: userModel!)
            ChatMainModel().loadMessages(websocket: websocket, chatModel:chatModel!, completition: { error in
                if(error != nil){
                    alertText = error!
                    showAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        dismiss()
                    })
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
    
    func upperUi() -> some View{
        return VStack(alignment: .leading){
            HStack{
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                Text(agentName)
                    .bold()
                Spacer()
                Text(websocket.userTyping == "" ? " " : "\(websocket.userTyping)  typing")
                    
                    .onChange(of: websocket.time, perform: {newVal in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                if(websocket.time <= .now()){
                                    websocket.userTyping = ""
                                    websocket.lastTyping = ""
                                }
                            })
                            
                        })
            
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            
        }
        .padding(.bottom, 8)
        .frame(height: 32)
        .frame(maxWidth: .infinity)
        .background(Color("LightGrey"))
    }
    
    func generateList() -> some View{
        return
        ScrollViewReader { sp in
            List((0..<websocket.messages.count).reversed(), id: \.self){ idx in
                VStack{
                    if(websocket.messages[idx].sender_username == userModel?.userName){
                        
                        HStack(alignment: .top, spacing: -2){
                            Spacer(minLength: 64)
                            ChatCell(messageModel: websocket.messages[idx], bgColor: "Blue")
                            
                                .upperCurve(20, corners: [.topLeft, .bottomLeft, .bottomRight])
                            
                        }
                    }
                    else{
                        HStack(alignment: .top, spacing: -2){
                            
                            ChatCell(messageModel: websocket.messages[idx], bgColor: "Orange")
                                .upperCurve(20, corners: [.topRight, .bottomLeft, .bottomRight])
                            Spacer(minLength: 64)
                        }
                        
                    }
                }
                .padding(.horizontal, 10)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                .onAppear(){
                        //sp.scrollTo(idx)
                    //print(idx)
                    
                    
                    
                }
            }.listStyle(.plain)
                .padding(.horizontal, -20)
                .scaleEffect(x: 1, y: -1, anchor: .center)
                
        }
        

    }
    func bottomUi() -> some View{
        return ZStack(alignment: .leading){
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
                if(textInTf.value == ""){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.005, execute: {
                        textInTfFocused = true
                    })
                    return
                }
                var tempTextInTf = textInTf.value
                message_queue.append(tempTextInTf)
                textInTf.value = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005, execute: {
                    textInTfFocused = true
                })
                if(message_queue.count != 1){
                    return
                }
                
                send_Message()
            })
            .focused($textInTfFocused)
            .padding(.leading, 16)
            .onChange(of: textInTf.value, perform: {
                newVal in
                if(chatModel != nil){
                    ChatMainModel.shared.sendTyping(chatModel: chatModel!)
                }
                
            })
            
        }
        .frame(maxWidth: .infinity)
        .background(Color("LightGrey"))
    }
    
    func send_Message(){
        if(message_queue.count < 1){
            return
        }
        ChatMainModel.shared.sendMessage(chatModel: chatModel!, textInTf: message_queue[0], completition: { error in
            message_queue.remove(at: 0)
            send_Message()
            /*
            if(error != nil){
                alertText = error!
                showAlert = true
                return
            }
             */
            
            
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
