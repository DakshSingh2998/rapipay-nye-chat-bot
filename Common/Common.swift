//
//  Common.swift
//  Chat
//
//  Created by Daksh on 20/03/23.
//

import Foundation
import UIKit
class Common{
    static var shared = Common()
    var privateKey = "9240f674-4630-4cad-819e-fd7c065b80cd"
    var projectId = "9789b39d-fa43-4419-8af6-b51fb4fefb35"
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    var currentOrientation = UIDevice.current.orientation
    
    var userDefaultName = ""
    var userDefaultPass = ""
    
    
    static var orientationUpdated: (() -> Void)?
    func updateOrientation(){
        var orientation = UIDevice.current.orientation
        currentOrientation = orientation
        if(orientation == .portrait || orientation == .portraitUpsideDown){
            print("Portrait")
            width = UIScreen.main.bounds.width
            height = UIScreen.main.bounds.height
        }
        if(orientation == .landscapeLeft || orientation == .landscapeRight){
            print("Landscape")
            width = UIScreen.main.bounds.width
            height = UIScreen.main.bounds.height
        }
        print(width, height)
        Common.orientationUpdated?()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidDate(_ inputValue: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale.current
        guard let date = dateFormatter.date(from: inputValue) else{
            return false
        }
        if(date <= Date.now){
            return true
        }
        return false
    }
    func isValidName(_ name:String) -> Bool{
        let emailRegEx = "(?<! )[-a-zA-Z' ]{2,26}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: name)
    }
    func isValidUserName(_ name:String) -> Bool{
        let emailRegEx = "(?<! )[-a-zA-Z0-9' ]{2,26}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: name)
    }
    func isValidPassword(_ password: String) -> Bool{
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
}
