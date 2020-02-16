//
//  travelModel.swift
//  FinalProject
//
//  Created by 王文贝 on 2019/12/8.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//

//import Foundation

//used for the data model
protocol travelDataModel {
    // return true for finding repeated users
    func checkRepeatUsername(username:String)->Bool
    
    // return true for verified
    func verify(username:String, password:String)->Bool
    

    // find the user in the user vectors
    func findUser(username:String)->Void
    
    // save to search history
//    func saveHistory(keyword:String, time:String)->Void
    
    // save data to the file
     func save()
}
