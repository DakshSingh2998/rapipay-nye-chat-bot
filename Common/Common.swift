//
//  Common.swift
//  Chat
//
//  Created by Daksh on 20/03/23.
//

import Foundation
import UIKit
import SwiftUI



class Common{
    static var shared = Common()
    var privateKey = "22b8844b-a242-4d70-87be-b9b74e60a901"
    var projectId = "e80b8656-fa4b-4b7d-8e0c-fbf44a35b470"
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
    func defaultJson() -> [String:String]{
        return ["Content-Type" : "application/json", "Accept" : "application/json"]
    }
    func addHeader(privateKey:Bool = false, projectId:Bool = false, userName:Bool = false, userSecret:Bool = false) -> [String:String]{
        var ans:[String:String] = [:]
        if(privateKey == true){
            ans["PRIVATE-KEY"] = Common.shared.privateKey
        }
        if(projectId == true){
            ans["Project-ID"] = Common.shared.projectId
        }
        if(userName == true){
            ans["User-Name"] = Common.shared.userDefaultName
        }
        if(userSecret == true){
            ans["User-Secret"] = Common.shared.userDefaultPass
        }
        return ans
    }
    
}

//general extension of view to round specific corners

extension View{
    func upperCurve(_ radius: CGFloat, corners: UIRectCorner) -> some View{
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner:Shape{
    var radius:CGFloat = . infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
