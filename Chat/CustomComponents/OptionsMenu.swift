//
//  OptionsMenu.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import SwiftUI

struct OptionsMenu: View {
    @Binding var ONPAGE: Double
    @Binding var userModel:UserModel?
    @State var gotoChatMain = false
    @State var chatModel:ChatModel?
    @State var alertText = ""
    @State var showAlert = false
    @State var randAgent:UserModel?
    @State var options:[String:[String]] = [:]
    @State var currentOptions:[String] = []
    @State var previousOption:[String] = []
    @State var refreshOptions = false
    var body: some View {
        ZStack{
            //ScrollView{
                VStack{
                    List(0..<previousOption.count, id: \.self){idx in
                        VStack(alignment: .leading){
                            HStack{
                                Spacer()
                                Text(previousOption[idx])
                            }
                            
                            if(idx == previousOption.count - 1){
                                OptionCell(currentOptions: $currentOptions, completition: { clickedText in
                                    currentOptions = options[clickedText]!
                                    previousOption.append(clickedText)
                                    refreshOptions = false
                                    refreshOptions = true
                                })
                                .frame(maxHeight: .infinity)
                            }
                            else{
                                EmptyView()
                            }
                        }.frame(maxHeight: .infinity)
                    }
                    .frame(maxHeight: .infinity)
                        
                    
                    
                }
            //}
            NavigationLink("ChatMain", destination: ChatMain(ONPAGE: $ONPAGE, userModel: $userModel, chatModel: $chatModel), isActive: $gotoChatMain).hidden()
        }
        .alert(alertText, isPresented: $showAlert, actions: {
            Button("OK", role: .cancel, action: {
                showAlert = false
            })
        })
        .onAppear(){
            OptionsMenuModel.shared.loadOptions(){ options in
                self.options = options!
                for i in self.options["root"]!{
                    currentOptions.append(i)
                }
                refreshOptions = true
                previousOption.append("Hi")
            }
        }
    }
    func createChat(){
        OptionsMenuModel.shared.createChat(userName: Common.shared.userDefaultName, pass: Common.shared.userDefaultPass, completition: {chatModel, error in
            if(error != nil){
                alertText = error!
                showAlert = true
                return
            }
            self.chatModel = chatModel!
            gotoChatMain = true
            
        })
    }
}

/*
struct OptionsMenu_Previews: PreviewProvider {
    static var previews: some View {
        OptionsMenu()
    }
}
*/
