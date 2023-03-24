//
//  LoadingScreen.swift
//  Final
//
//  Created by Daksh on 06/03/35.
//

import SwiftUI

struct LoadingScreen: View {
    @State var ONPAGE:Double = 0.0
    var body: some View{
        ZStack{
            NavigationView{
                if(ONPAGE == 0.0){
                    ProgressView()
                }
                else{
                    LogIn(ONPAGE: $ONPAGE)
                }
            }
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                ONPAGE = 1.0
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)){_ in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
             Common.shared.updateOrientation()
                /*
                self.width = Common.shared.width
                self.tfWidth = Common.shared.width - 100
                self.height = Common.shared.height
                 */
                print(Common.shared.width)
                 
            }
             
            
        }
    }
}
/*
 struct LoadingScreen_Previews: PreviewProvider {
 static var previews: some View {
 LoadingScreen()
 }
 }
 */
