//
//  AllChats.swift
//  Chat
//
//  Created by Daksh on 21/03/23.
//

import SwiftUI

struct AllChats: View {
    @Binding var ONPAGE:Double
    @Binding var userModel:UserModel?
    @State var gotoOptionsMenu = false
    @State var alertText = ""
    @State var showAlert = false
    @State var allChats:[ChatModel] = []
    @State var chatModel:ChatModel?
    @State var gotoChatMain = false
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack{
                Spacer()
                List(0..<allChats.count, id: \.self){idx in
                    Text("\(allChats[idx].id)").onTapGesture {
                        chatModel = allChats[idx]
                        gotoChatMain = true
                    }
                }
                NavigationLink("OptionsMenu", destination: OptionsMenu(ONPAGE: $ONPAGE, userModel: $userModel), isActive: $gotoOptionsMenu)
                    .hidden()
                NavigationLink("ChatMain", destination: ChatMain(ONPAGE: $ONPAGE, userModel: $userModel, chatModel: $chatModel), isActive: $gotoChatMain).hidden()
            
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 64)
            
                Text("+")
                    .font(Font(CTFont(.system, size: 32))).bold()
                    .foregroundColor(Color("White"))
                    .padding(32)
                    .background(Color("Orange"))
                    .clipShape(Circle())
                    .padding(.trailing, 16)
                    .onTapGesture {
                        gotoOptionsMenu = true
                    }
            
                    
        }.alert(alertText, isPresented: $showAlert, actions: {
            Button("OK", role: .cancel, action: {
                showAlert = false
            })
        })
        
        .onAppear(){
            AllChatsModel.shared.getChats(userName: Common.shared.userDefaultName, pass: Common.shared.userDefaultPass, completition: {allChats, error in
                if(error != nil){
                    alertText = error!
                    showAlert = true
                    return
                }
                self.allChats = allChats!
                
            })
        }
        .navigationTitle("Chats")

    }
}
