//
//  ChatCell.swift
//  Chat
//
//  Created by Daksh on 23/03/23.
//

import SwiftUI

struct ChatCell: View {
    @State var messageModel:MessageModel
    @State var chatModel:ChatModel
    @State var textViewHeight:CGFloat = 0.0
    @State var textViewHeight2:CGFloat = 0.0
    @State var bgColor = "LightGrey"
    let dateFormatter = ISO8601DateFormatter()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    Text(messageModel.sender_username)
                        .font(Font(CTFont(.system, size: 16)))
                        .bold()
                    if(textViewHeight != 0){
                        Spacer().frame(maxWidth: textViewHeight - textViewHeight2)
                    }
                    else{
                        EmptyView()
                    }
                    
                    Text(ChatMainModel.shared.stringToTime(isoDate: messageModel.created))
                        .font(Font(CTFont(.system, size: 14)))
                        .foregroundColor(Color("DarkGrey"))
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                if(textViewHeight2 != 0){
                                    return
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
                                    
                                    self.textViewHeight2 =  proxy.size.width
                                    
                                })
                                
                            }
                    }
                )
                
                Text(messageModel.text)
                    .padding(.top, 0.5)
                    .lineLimit(100)
                
                
                
            }.padding(.all, 10)
            //.background()
                .background(
                    GeometryReader { proxy in
                        Color(bgColor)
                            .onAppear {
                                if(textViewHeight != 0){
                                    return
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005, execute: {
                                    self.textViewHeight =  proxy.size.width
                                })
                                
                            }
                    }
                )
            if(checkSeen() && messageModel.created != "" && messageModel.sender_username == Common.shared.userDefaultName){
                Image("DoubleTick").resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .padding(.trailing, 1)
            }
            else{
                EmptyView()
            }
            
        }
    }
    func checkSeen() -> Bool{
        var people = chatModel.people
        for i in people{
            if((i["last_read"] as? Int ?? -1) <  messageModel.id){
                return false
            }
        }
        return true
        
    }
}

