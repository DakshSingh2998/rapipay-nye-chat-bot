//
//  LoadingScreen.swift
//  Final
//
//  Created by Daksh on 06/03/35.
//

import SwiftUI

struct LoadingScreen: View {
    @State var ONPAGE:Double = 0.0
    @StateObject var networkMonitor = NetworkMonitor()
    @State var userModel:UserModel?
    @State var showCommonAlert = false
    @State var commonAlertText = ""
    var body: some View{
        ZStack{
            NavigationView{
                if(ONPAGE == 0.0){
                    ProgressView()
                }
                else if( ONPAGE < 2.0){
                    LogIn(ONPAGE: $ONPAGE, userModel: $userModel)
                }
                else{
                    AllChats(ONPAGE: $ONPAGE, userModel: $userModel)
                }
                EmptyView().alert(commonAlertText, isPresented: $showCommonAlert, actions: {
                    Button("OK", role: .cancel, action: {
                        showCommonAlert = false
                    })
                })
            }
        }
        
        .onChange(of: networkMonitor.status) { connection in
            if(connection == .connected){
                commonAlertText = "We are back Online"
            }
            else{
                commonAlertText = "Network Not Available"
            }
            
            showCommonAlert = true
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                let userName = UserDefaults.standard.value(forKey: "user") as? String
                let pass = UserDefaults.standard.value(forKey: "pass") as? String
                if(userName == nil || pass == nil){
                    ONPAGE = 1.0
                }
                else{
                    LoginModel.shared.getUser(tempUser: userName!, tempPass: pass!, completition: { userModel, error in
                        if(userModel == nil && error != nil){
                            ONPAGE = 1.0
                            return
                        }
                        else if(userModel == nil && error == nil){
                            ONPAGE = 1.0
                            return
                        }
                        self.userModel = userModel
                        ONPAGE = 2.0
                        
                    })
                }
                
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
