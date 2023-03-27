//
//  ChatMainModel.swift
//  Chat
//
//  Created by Daksh on 24/03/23.
//

import Foundation
class ChatMainModel{
    static var shared = ChatMainModel()
    func stringToTime(isoDate:String) -> String{
          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
          let date = dateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
          let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let convertDateFormatter = DateFormatter()
             convertDateFormatter.dateFormat = "h:mm a"

        return convertDateFormatter.string(from: date)
    }
}
