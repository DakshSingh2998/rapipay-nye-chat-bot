//
//  OptionsMenu.swift
//  Chat
//
//  Created by Daksh on 22/03/23.
//

import SwiftUI

struct OptionsMenu: View {
    @Environment(\.dismiss) var dismiss

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
                                    .lineLimit(100)
                                    .font(.system(size: 16))
                                    .bold()
                                    .padding(.all, 10)
                                    
                                //.border(Color("Blue"))
                                    .cornerRadius(10)
                                    .background(Color("Blue"))
                                    .cornerRadius(10)
                                    .overlay{RoundedRectangle(cornerRadius: 10.0, style: .continuous).stroke( Color("Orange"), lineWidth: 2)}
                                    .cornerRadius(10)
                            }
                            
                            if(idx == previousOption.count - 1){
                                OptionCell(currentOptions: $currentOptions, completition: { clickedText in
                                    if(clickedText == "Talk to Customer Care"){
                                        createChat()
                                        return
                                    }
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
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                        //.listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                        .frame(maxHeight: .infinity)
                    }
                    .listStyle(.plain)
                        .padding(.horizontal, 0)
                    .frame(maxHeight: .infinity)
                        
                    
                    
                }
            //}
            NavigationLink("ChatMain", destination: ChatMain(ONPAGE: $ONPAGE, userModel: $userModel, chatModel: $chatModel), isActive: $gotoChatMain).hidden()
        }
        .navigationTitle("Help")
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
        OptionsMenuModel.shared.createChat(userName: Common.shared.userDefaultName, pass: Common.shared.userDefaultPass, previousOption: previousOption[previousOption.count - 1], completition: {chatModel, error in
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
