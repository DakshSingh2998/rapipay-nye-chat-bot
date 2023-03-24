//
//  OptionsMenuModel.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import Foundation
class OptionsMenuModel{
    static var shared  = OptionsMenuModel()
    
    func createChat(userName:String, pass:String, completition:((ChatModel?, String?) -> ())?){
        var chatModel:ChatModel?
        var randAgent:UserModel?
        var dg = DispatchGroup()
        var completed = 0
        dg.enter()
        ChatApi.shared.createChat(userName: userName, pass: pass, completition: {data, error in
            guard let data = data as? [String: Any] else {
                completition?(nil, (error as! Error).localizedDescription)
                dg.leave()
                return
            }
            chatModel = ChatModel(data: data)
            completed = completed + 1
            dg.leave()
        })
        dg.enter()
        UserApi.shared.getUsers(completition: {data, error in
            guard let data = data as? [[String:Any]] else{
                completition?(nil, (error as! Error).localizedDescription)
                dg.leave()
                return
            }
            var usersModel = data.map{UserModel(data: $0)}
            var agents:[UserModel] = []
               for i in usersModel{
                   if(i.email.starts(with: "agent")){
                       agents.append(i)
                   }
               }
               let randomAgent = Int.random(in: 0..<agents.count)
            randAgent = usersModel[randomAgent]
            completed = completed + 1

            dg.leave()
        })
        dg.notify(queue: DispatchQueue.global(qos: .utility), execute: {
            if(completed == 2){
                ChatApi.shared.addMember(chatId: chatModel!.id, userName: userName, pass: pass, userModelToAdd: randAgent!.userName, completition: {data, error in
                    guard let data = data as? [String: Any] else {
                        completition?(nil, (error as! Error).localizedDescription)
                        return
                    }
                    completition?(chatModel, nil)
                })
                
            }
        })
    }
    
    func loadOptions(completition: (([String: [String]]?) ->())?){
        var options = DatabaseHelper.shared.loadOptions()
        var finalOptions:[String: [String]] = [:]
        for i in options{
            if(finalOptions[i.text!] == nil){
                finalOptions[i.text!] = []
                if(i.toMany == nil){
                    continue
                }
                for j in i.toMany!{
                    finalOptions[i.text!]?.append((j as! TDataCore).text!)
                }
            }
        }
        completition?(finalOptions)
    }
    
}
