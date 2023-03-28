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
    @State var topPadding:CGFloat = -32

    var body: some View {
            
            VStack(spacing: 0){
                EmptyView()
                upperUi()
                
                generateList()
                Spacer()
                
                bottomUi()
                
            
            //.background(Color.blue)
            
        }
            .navigationTitle("Customer Care")
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    ChatMainModel.shared.typingChange(lastTextInTf: lastTextInTf, textInTf: textInTf.value, chatModel: chatModel!)
                    lastTextInTf = textInTf.value
                    })
            })
            for i in chatModel!.people{
                if((i["person"] as! [String:Any])["username"]as! String != userModel?.userName){
                    agentName = (i["person"] as! [String:Any])["username"]as! String
                }
            }
             
            guard let userName = UserDefaults.standard.value(forKey: "user") as? String else{
                return
            }
            var pass = UserDefaults.standard.value(forKey: "pass") as! String
            
            ChatApi.shared.getMessages(userName: userName, pass: pass, chatId: chatModel!.id, completition: {data, error in
                guard let data = data as? [[String: Any]] else {
                    alertText = (error as! Error).localizedDescription
                    showAlert = true
                    return
                }
                DispatchQueue.main.async {
                    websocket.messages = data.map{
                        MessageModel(data: $0)
                    }
                    websocket.connect(chatModel: chatModel)
                    
                }
                
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if(Common.shared.currentOrientation == .portrait){
                    topPadding = -42
                }
                else{
                    topPadding = 0
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
                if(Common.shared.currentOrientation == .portrait){
                    topPadding = -42
                }
                else{
                    topPadding = 0
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
                    .padding(.leading, 10)
                Spacer()
                VStack(alignment: .leading){
                    Text(agentName)
                        .bold()
                        .frame(maxWidth: .infinity)
                    Text(websocket.userTyping == "" ? " " : "\(websocket.userTyping)  typing")
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)

                        .onChange(of: websocket.time, perform: {newVal in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                if(websocket.time <= .now()){
                                    websocket.userTyping = ""
                                    websocket.lastTyping = ""
                                }
                            })
                            
                        })
                }
                .frame(maxWidth: .infinity)
                .padding(.trailing, 52)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(.bottom, 4)
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
                            ChatCell(messageModel: websocket.messages[idx])
                            
                                .upperCurve(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                            Image(systemName: "arrowtriangle.forward.fill")
                                .foregroundColor(Color("LightGrey"))
                                .padding(.top, 0)
                        }
                    }
                    else{
                        HStack(alignment: .top, spacing: -2){
                            Image(systemName: "arrowtriangle.backward.fill")
                                .foregroundColor(Color("LightGrey"))
                                .padding(.top, 0)
                            ChatCell(messageModel: websocket.messages[idx])
                                .upperCurve(10, corners: [.topRight, .bottomLeft, .bottomRight])
                            Spacer(minLength: 64)
                        }
                        
                    }
                }
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
                ChatMainModel.shared.sendMessage(chatModel: chatModel!, textInTf: textInTf.value, completition: { error in
                    if(error != nil){
                        alertText = error!
                        showAlert = true
                        return
                    }
                    textInTf.value = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        textInTfFocused = true
                    })
                    
                    
                })
            })
            .focused($textInTfFocused)
            .padding(.leading, 16)
            
            
        }
        .frame(maxWidth: .infinity)
        .background(Color("LightGrey"))
    }
}

/*
struct ChatMain_Previews: PreviewProvider {
    static var previews: some View {
        ChatMain()
    }
}

*/
