//
//  CustomDynamicButton.swift
//  Chat
//
//  Created by Daksh on 21/03/23.
//
import SwiftUI

struct CustomDynamicButton: View{
    @State var title = "Button"
    @State var height:CGFloat = 50
    @Binding var colorr:Color
    @Binding var borderColor:Color
    @Binding var textColor:Color
    var closure: (() -> Void)?
    var body: some View {
        Button(action: closure ?? {
            print("Button Action not Defined")
        },label:{
            Spacer()
            Text(title).fontWeight(.bold)
            Spacer()
        })
        .frame(maxWidth: .infinity, minHeight: height).overlay{RoundedRectangle(cornerRadius: 8.0, style: .continuous).stroke( borderColor == nil ? colorr : borderColor, lineWidth: 6)}.background(colorr).cornerRadius(8.0).foregroundColor(textColor)
        //.buttonStyle(CustomButtonStyle())
        
    }
}


