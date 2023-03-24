//
//  SignUpModel.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import Foundation
class SignUpModel{
    static var shared = SignUpModel()
    func checkValidity(vmUserName:String, vmFirstName:String, vmLastName:String, vmPassword:String, completition: ((Bool, Bool, Bool, Bool, Bool) -> ())?){
        var isUserNameIncorrect = true
        var isFirstNameIncorrect = true
        var isLastNameIncorrect = true
        var isPasswordIncorrect = true
        var signUpButtonEnabled = true


        var tempIsValidUserName = Common.shared.isValidUserName(vmUserName)
        if(tempIsValidUserName){
            isUserNameIncorrect = false
        }
        var tempIsValidFirstName = Common.shared.isValidName(vmFirstName)
        if(tempIsValidFirstName){
            isFirstNameIncorrect = false
        }
        var tempIsValidLastName = Common.shared.isValidName(vmLastName)
        if(tempIsValidLastName){
            isLastNameIncorrect = false
        }
        var tempIsValidPassword = Common.shared.isValidPassword(vmPassword)
        if(tempIsValidPassword){
            isPasswordIncorrect = false
        }
        if(tempIsValidUserName && tempIsValidFirstName && tempIsValidLastName && tempIsValidPassword){
            signUpButtonEnabled = true
        }
        else{
            signUpButtonEnabled = false
        }
        completition?(isUserNameIncorrect, isFirstNameIncorrect, isLastNameIncorrect, isPasswordIncorrect, signUpButtonEnabled)
    }
    
    func createUser(vmUserName:String, vmFirstName:String, vmLastName:String, vmPassword:String, completition: ((String) -> ())?){
        UserApi.shared.createUser( userName: vmUserName, firstName: vmFirstName, lastName: vmLastName, password: vmPassword, completition:{
            data, error in
                guard let data = data as? [String: Any] else {
                    completition?("\((error as! Error).localizedDescription)")
                    return
                }
                if(data["message"] != nil){
                    completition?(data["message"] as! String)
                    return
                }
                
        })
    }
    
}
