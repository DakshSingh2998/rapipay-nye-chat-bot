//
//  AllChats.swift
//  Chat
//
//  Created by Daksh on 21/03/23.
//

import SwiftUI

struct AllChats: View {
    @Environment(\.dismiss) var dismiss
    @Binding var ONPAGE:Double
    @Binding var userModel:UserModel?
    @State var gotoOptionsMenu = false
    @State var alertText = ""
    @State var showAlert = false
    @State var allChats:[ChatModel?] = []
    @State var chatModel:ChatModel?
    @State var gotoChatMain = false
    @State var showUi = true
    @State var apiLoaded = false
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            if(apiLoaded == true){
                VStack{
                    Spacer()
                    if(allChats.count != 0){
                        generateList()
                    }
                    else{
                        Spacer()
                        Text("Start a Chat")
                            .padding(.bottom, 64)
                        Spacer()
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 64)
                .background(Color("LightGrey"))
                .cornerRadius(20)
                .padding(.horizontal, 14)
                .padding(.bottom, 6)
            }
            else{
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            NavigationLink("OptionsMenu", destination: OptionsMenu(ONPAGE: $ONPAGE, userModel: $userModel), isActive: $gotoOptionsMenu)
                .hidden()
            NavigationLink("ChatMain", destination: ChatMain(ONPAGE: $ONPAGE, userModel: $userModel, chatModel: $chatModel), isActive: $gotoChatMain).hidden()
            Text("+")
                .font(Font(CTFont(.system, size: 32))).bold()
                .foregroundColor(Color("White"))
                .padding(32)
                .background(Color("Orange"))
                .clipShape(Circle())
                .padding(.trailing, 16)
                .onTapGesture {
                    ONPAGE = 2.1
                    gotoOptionsMenu = true
                }
        
        }.alert(alertText, isPresented: $showAlert, actions: {
            Button("OK", role: .cancel, action: {
                showAlert = false
            })
        })
        
        .onAppear(){
            apiLoaded = false
            AllChatsModel.shared.getChats(userName: Common.shared.userDefaultName, pass: Common.shared.userDefaultPass, completition: {allChats, error in
                if(error != nil || allChats == nil){
                    if(error != nil){
                        alertText = error!
                    }
                    else{
                        alertText = "Network Error"
                    }
                    
                    showAlert = true
                    return
                }
                
                self.allChats = allChats!
                apiLoaded = true
                
                
            })
        }
        .navigationTitle("Chats")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("LogOut"){
                    UserDefaults.standard.removeObject(forKey: "pass")
                    UserDefaults.standard.removeObject(forKey: "user")
                    
                    ONPAGE = 1.0
                }
            })
        })
        

    }
    func generateList() -> some View{
        List(0..<allChats.count, id: \.self){idx in
            HStack{
                AllChatsCell(messageModel: MessageModel(data: allChats[idx]!.last_message), chatModel: allChats[idx]!)
                    .background(Color("Blue"))
                    .frame(maxWidth: .infinity)
                    .background(Color("Blue"))
                Text(">").bold()
                    .padding(.horizontal, 10)
            }
            .cornerRadius(20)
            .background(Color("Blue"))
            .cornerRadius(20)
            .padding(.horizontal, 10)
            .cornerRadius(20)
            
            .onTapGesture {
                if(allChats[idx] == nil){
                    return
                }
                chatModel = allChats[idx]
                ONPAGE = 3.0
                gotoChatMain = true
            }
            
                .listRowBackground(Color.clear)
                //.listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .cornerRadius(10)
        }
        .cornerRadius(10)
        .listStyle(.plain)
        .padding(.horizontal, -20)
    }
}
