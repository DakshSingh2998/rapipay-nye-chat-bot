//
//  OptionsMenuModel.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import Foundation
class OptionsMenuModel{
    static var shared  = OptionsMenuModel()
    
    func createChat(userName:String, pass:String,previousOption:String, completition:((ChatModel?, String?) -> ())?){
        var chatModel:ChatModel?
        var randAgent:UserModel?
        
        UserApi().getUsers(completition: {data, error in
            guard let data = data as? [[String:Any]] else{
                if(error != nil){
                    completition?(nil, (error as! Error).localizedDescription)
                }
                else{
                    completition?(nil, "Api Error")
                }
                
                return
            }
            var usersModel = data.map{UserModel(data: $0)}
            var agents:[UserModel] = []
               for i in usersModel{
                   if(i.email.starts(with: "agent")){
                       agents.append(i)
                   }
               }
            randAgent = agents.randomElement()
            
            ChatApi.shared.createChat(userName: userName, pass: pass, previousOption: previousOption, userToAdd: randAgent!.userName, completition: {data, error in
                guard let data = data as? [String: Any] else {
                    if(error != nil){
                        completition?(nil, (error as! Error).localizedDescription)
                    }
                    else{
                        completition?(nil, "Api Error")
                    }
                    return
                }
                chatModel = ChatModel(data: data)
                completition?(chatModel, nil)
                return
            })
        })
        
        
    }
    
    func loadOptions(completition: (([String: [String]]?) ->())?){
        var options = DatabaseHelper.shared.loadOptions()
        var finalOptions:[String: [String]] = [:]
        for i in options{
            if(finalOptions[i.text!] == nil){
                finalOptions[i.text!] = []
                if(i.children == nil){
                    continue
                }
                for j in i.children!{
                    finalOptions[i.text!]?.append((j as! TDataCore).text!)
                }
            }
        }
        completition?(finalOptions)
    }
    
}
