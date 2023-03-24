//
//  ChatCell.swift
//  Chat
//
//  Created by Daksh on 23/03/23.
//

import SwiftUI

struct ChatCell: View {
    @State var messageModel:MessageModel
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                Text(messageModel.sender_username)
                Spacer()
                Text(messageModel.created)
            }
            Text(messageModel.text)
                .lineLimit(0)
                .frame(maxWidth: .infinity)
        }
        .background(Color("LightGrey"))
    }
}

