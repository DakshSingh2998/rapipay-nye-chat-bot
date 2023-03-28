//
//  AllChatsModel.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import Foundation
class AllChatsModel{
    static var shared = AllChatsModel()
    
    func getChats(userName: String, pass: String, completition: (([ChatModel]?, String?) -> ())?){
        ChatApi.shared.getChats(userName: userName, pass: pass, completition: {data, error in
            var allChats:[ChatModel]
            guard let data = data as? [[String: Any]] else {
                if(error != nil){
                    completition?(nil, (error as! Error).localizedDescription)
                }
                else{
                    completition?(nil, "Api Error")
                }
                return
            }
            allChats = data.map{
                ChatModel(data: $0)
            }
            completition?(allChats, nil)
            
            
        })
    }
    
}
