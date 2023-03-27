//
//  OptionCell.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import SwiftUI

struct OptionCell: View {
    @Binding var currentOptions:[String]
    @State var completition:((String) -> ())?
    var body: some View {
        VStack(alignment: .leading){
            if(currentOptions.count != 0){
                ForEach(currentOptions, id: \.self){curOption in
                    Text(curOption)
                        .font(.system(size: 16))
                        .bold()
                        .padding(.all, 10)
                    //.border(Color("Blue"))
                        .cornerRadius(10)
                        .background(Color("Orange"))
                        .cornerRadius(10)
                        .overlay{RoundedRectangle(cornerRadius: 10.0, style: .continuous).stroke( Color("Blue"), lineWidth: 2)}
                        .cornerRadius(10)
                        .onTapGesture {
                            completition?(curOption)
                        }
                }
            }
            else{
                Text("Talk to Customer Care")
                    .font(.system(size: 16))
                    .bold()
                    .padding(.all, 10)
                //.border(Color("Blue"))
                    .cornerRadius(10)
                    .background(Color("Orange"))
                    .cornerRadius(10)
                    .overlay{RoundedRectangle(cornerRadius: 10.0, style: .continuous).stroke( Color("Blue"), lineWidth: 2)}
                    .cornerRadius(10)
                    .onTapGesture {
                        completition?("Talk to Customer Care")
                    }
                
            }
        }
        .onAppear(){
        }
    }
    
}
/*
 struct OptionCell_Previews: PreviewProvider {
 static var previews: some View {
 OptionCell()
 }
 }
 */
