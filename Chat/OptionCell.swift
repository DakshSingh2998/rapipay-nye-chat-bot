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
            ForEach(currentOptions, id: \.self){curOption in
                Text(curOption)
                    .onTapGesture {
                        completition?(curOption)
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
