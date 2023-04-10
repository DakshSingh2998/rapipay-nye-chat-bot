//
//  DatabaseHelper.swift
//  First
//
//  Created by Daksh on 09/02/23.
//

import CoreData
import UIKit
import Foundation
import SwiftUI
struct DatabaseHelper{
    //@Environment(\.managedObjectContext) var context
    var context = PersistenceController.shared.container.viewContext
    func saveOption(text:String, parents:[TDataCore]? = nil) -> TDataCore{
        let obj = NSEntityDescription.insertNewObject(forEntityName: "TDataCore", into: context) as! TDataCore
        obj.text = text
        if(parents != nil){
            for i in parents!{
                i.addToChildren(obj)
                obj.addToParents(i)
            }
            
        }
        do{
            try? context.save()
        }
        catch{
            print("Error in saving")
        }
        return obj
    }
    
    
    
    func loadOptions() -> [TDataCore]{
        var obj:[TDataCore] = []
        //let fetchreq = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        do{
            obj = try context.fetch(NSFetchRequest(entityName: "TDataCore")) as! [TDataCore]
            
        }
        catch{
            print("Error in loading")
        }
        return obj
    }
}

