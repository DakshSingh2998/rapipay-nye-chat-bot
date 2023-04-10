//
//  temp.swift
//  Chat
//
//  Created by Daksh on 23/03/23.
//

import Foundation
import SwiftUI

struct Temp{
    init(){
        
        
        //what to save in database ie options graph.
        //and why graph cause every node can have multiple parents and multiple children. so yeah it is a graph.
        
        /*
        
        var savedOption:[String: TDataCore] = [:]
        
        savedOption["root"] = DatabaseHelper().saveOption(text: "root")
        var parents:[TDataCore] = []
        parents.append(savedOption["root"]!)
        
        savedOption["NYE Prepaid Card"] = DatabaseHelper().saveOption(text: "NYE Prepaid Card", parents: parents)
        savedOption["Open Account"] = DatabaseHelper().saveOption(text: "Open Account", parents: parents)
        savedOption["Rapi Money"] = DatabaseHelper().saveOption(text: "Rapi Money", parents: parents)
        savedOption["UPI Payments"] = DatabaseHelper().saveOption(text: "UPI Payments", parents: parents)
         
         
        parents = []
        parents.append(savedOption["NYE Prepaid Card"]!)
        parents.append(savedOption["Open Account"]!)
        savedOption["Login to NYE Banking App"] = DatabaseHelper().saveOption(text: "Login to NYE Banking App", parents: parents)
         
         
         
        parents = []
        parents.append(savedOption["NYE Prepaid Card"]!)
        
        savedOption["Change PIN"] = DatabaseHelper().saveOption(text: "Change PIN", parents: parents)
        savedOption["Block Card"] = DatabaseHelper().saveOption(text: "Block Card", parents: parents)
        savedOption["Issue a new Card"] = DatabaseHelper().saveOption(text: "Issue a new Card", parents: parents)
        
        
        parents = []
        parents.append(savedOption["Login to NYE Banking App"]!)
        savedOption["Testing"] = DatabaseHelper().saveOption(text: "Testing", parents: parents)
        
         
         */
    }
}
