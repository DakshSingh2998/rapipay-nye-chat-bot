//
//  SignUp.swift
//  Chat
//
//  Created by Daksh on 20/03/23.
//

import SwiftUI
import CoreData


class TextModel:ObservableObject{
    @Published var value = ""
    
}

struct SignUp: View {
    @Environment(\.dismiss) var dismiss
    @Binding var ONPAGE:Double
    @ObservedObject var vmUserName = TextModel()
    @ObservedObject var vmFirstName = TextModel()
    @ObservedObject var vmLastName = TextModel()
    @ObservedObject var vmPassword = TextModel()
    @FocusState var userNameFocus:Bool
    @FocusState var firstNameFocus:Bool
    @FocusState var lastNameFocus:Bool
    @FocusState var passwordFocus:Bool
    @State var height = Common.shared.height
    @State var temp = ""
    @State var width = Common.shared.width
    @State var tfWidth = Common.shared.width - 100
    @State var isUserNameIncorrect = false
    @State var isFirstNameIncorrect = false
    @State var isLastNameIncorrect = false
    @State var isPasswordIncorrect = false
    @State var successfulSignup = false
    @State var alertText = ""
    @State var signUpButtonEnabled = false
    @State var commonAlert = ""
    @State var showCommonAlert = false
    @State var buttonColor = Color("Grey")
    @State var buttonTextColor = Color("White")
    @State var backgroundOpacity = 1.0
    var coloredSignIn: AttributedString{
        var result = AttributedString("Sign In")
        result.foregroundColor = Color("Blue")
        result.font = .boldSystemFont(ofSize: 16)
        return result
    }
    
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                VStack(spacing: -8){
                    
                    Image(uiImage: UIImage(named: "Rapipay_SignUp")!).resizable()
                        .frame(width: 250, height: 200)
                        .scaledToFill()
                    
                        .padding(.bottom, 32)

                    CustomTextField(defaultplaceholder: "User Name", vm: vmUserName, width: $tfWidth, isInCorrect: $isUserNameIncorrect, commitClosure: {
                        if(Common.shared.isValidUserName(vmUserName.value) == false){
                            isUserNameIncorrect = true
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                userNameFocus = true
                            }
                            return
                        }
                        else{
                            //isUserNameIncorrect = false
                        }
                        isFirstNameIncorrect = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            firstNameFocus = true
                        }
                    }).focused($userNameFocus).onTapGesture {
                        isUserNameIncorrect = false
                    }
                    CustomTextField(defaultplaceholder: "First Name", vm: vmFirstName, width: $tfWidth, isInCorrect: $isFirstNameIncorrect, commitClosure: {
                        if(Common.shared.isValidName(vmFirstName.value) == false){
                            isFirstNameIncorrect = true
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                firstNameFocus = true
                            }
                            return
                        }
                        else{
                            //isFirstNameIncorrect = false
                        }
                        isLastNameIncorrect = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            lastNameFocus = true
                        }
                    }).focused($firstNameFocus).onTapGesture {
                        isFirstNameIncorrect = false
                    }
                    CustomTextField(defaultplaceholder: "Last Name", vm: vmLastName, width: $tfWidth, isInCorrect: $isLastNameIncorrect, commitClosure: {
                        if(Common.shared.isValidName(vmLastName.value) == false){
                            isLastNameIncorrect = true
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                lastNameFocus = true
                            }
                            return
                        }
                        else{
                            //isLastNameIncorrect = false
                        }
                        isPasswordIncorrect = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            passwordFocus = true
                        }
                    }).focused($lastNameFocus).onTapGesture {
                        isLastNameIncorrect = false
                    }
                    
                    CustomTextField(defaultplaceholder: "Password", vm: vmPassword, width: $tfWidth, isProtected: true, isInCorrect: $isPasswordIncorrect, commitClosure: {
                        print(vmPassword.value)
                        if(Common.shared.isValidPassword(vmPassword.value) == false){
                            isPasswordIncorrect = true
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                passwordFocus = true
                            }
                            return
                        }
                        else{
                            //isPasswordIncorrect = false
                        }
                        isUserNameIncorrect = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            userNameFocus = true
                        }
                    }).focused($passwordFocus).onTapGesture {
                        isPasswordIncorrect = false
                    }
                    HStack{
                        Spacer()
                    }
                    .frame(height: 32)
                    
                    CustomDynamicButton(title: "Sign up", colorr: $buttonColor , borderColor: $buttonColor, textColor: $buttonTextColor ){
                        backgroundOpacity = 0.2
                        createUser()
                    }
                    .allowsHitTesting(signUpButtonEnabled)
                }
                
                .padding(.horizontal, 50)
                .frame(minHeight: self.height - self.height/5)
            }
            .allowsHitTesting(backgroundOpacity == 1.0 ? true : false)
            .opacity(backgroundOpacity)
            .navigationTitle("SignUp")
            .alert(alertText, isPresented: $successfulSignup, actions: {
                Button("LOGIN", role: .cancel, action: {
                    successfulSignup = false
                    try? dismiss()
                })
            })
            .alert(commonAlert, isPresented: $showCommonAlert, actions: {
                Button("OK", role: .cancel, action: {
                    showCommonAlert = false
                })
            })
            if(backgroundOpacity != 1.0){
                ProgressView{
                    
                }
                .contentShape(Rectangle())
                    .backgroundStyle(Color("White"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            }
            
        }
        
        .onAppear(){
            print("ONPAGE2 \(ONPAGE)")
            self.width = Common.shared.width
            self.height = Common.shared.height
            self.tfWidth = Common.shared.width - 100
            userNameFocus = true
            vmUserName.value = "daksh2998"
            vmFirstName.value = "Daksh"
            vmLastName.value = "Singh"
            vmPassword.value = "Daksh@90"
        }
        .onDisappear(){
            vmUserName.value = ""
            vmFirstName.value = ""
            vmLastName.value = ""
            vmPassword.value = ""
            
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)){_ in
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                self.width = Common.shared.width
                self.tfWidth = Common.shared.width - 100
                self.height = Common.shared.height
            }
            
        }
        
        .onChange(of: vmUserName.value){newVal in
            checkValidity()
        }
        .onChange(of: vmFirstName.value){newVal in
            checkValidity()
        }
        .onChange(of: vmLastName.value){newVal in
            checkValidity()
        }
        .onChange(of: vmPassword.value){newVal in
            checkValidity()
        }
    }
    func createUser(){
        backgroundOpacity = 0.2
        SignUpModel.shared.createUser(vmUserName: vmUserName.value, vmFirstName: vmFirstName.value, vmLastName: vmLastName.value, vmPassword: vmPassword.value, completition: {
            error in
            backgroundOpacity = 1.0
            if(error != nil){
                commonAlert = error
                showCommonAlert = true
                return
            }
            alertText = "SignUp Successful :)"
            successfulSignup = true
            
        })
    }
    func checkValidity(){
        SignUpModel.shared.checkValidity(vmUserName: vmUserName.value, vmFirstName: vmFirstName.value, vmLastName: vmLastName.value, vmPassword: vmPassword.value, completition: {
            isUserNameIncorrect,
            isFirstNameIncorrect,
            isLastNameIncorrect,
            isPasswordIncorrect,
            signUpButtonEnabled in
            if(isUserNameIncorrect == false){
                self.isUserNameIncorrect = false
            }
            if(isFirstNameIncorrect == false){
                self.isFirstNameIncorrect = false
            }
            if(isLastNameIncorrect == false){
                self.isLastNameIncorrect = false
            }
            if(isPasswordIncorrect == false){
                self.isPasswordIncorrect = false
            }
            self.signUpButtonEnabled = signUpButtonEnabled
            if(self.signUpButtonEnabled == true){
                buttonColor = Color("Purple")
            }
            else{
                buttonColor = Color("Grey")

            }
            
        })
    }
}
extension View{
    @ViewBuilder func isHidden(_ hide:Bool) -> some View {
        if hide{
            self.hidden()
        }
        else{
            self
        }
    }
}
