//
//  travelUser.swift
//  FinalProject
//
//  Created by 王文贝 on 2019/12/8.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//

import Foundation
struct Record {
    public var date: String
    public var keywords: [String]
    public var recordText : String
    public var recordJson : String
    init(date: String, keywords: [String], recordText: String, recordJson: String) {
        self.date = date
        self.keywords = keywords
        self.recordText = recordText
        self.recordJson = recordJson
        
    }
}
struct User:Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        let areEqual = lhs.username == rhs.username &&
            lhs.password == rhs.password
        return areEqual
    }
    
    private var username : String
    private var password : String
    public var currentDate : String?
    public var historyRecords : [Record]
    public var currentIndex:Int
    
    func getUsername() -> String {
        return username
    }
    func getPassword() -> String {
        return password
    }
    mutating func addRecord(r: Record) -> Void {
        historyRecords.append(r)
    }
//    mutating func getRecordsAsString()
    init(username: String, password: String){
        self.username = username
        self.password = password
        self.currentIndex = 0
        self.historyRecords = []
    }
    mutating func getCurrentRecord()->Record{
        if currentIndex >= 0 && currentIndex < historyRecords.count{
            return historyRecords[currentIndex]
        }
        else {
            return Record(date: "", keywords: [], recordText: "", recordJson: "")
        }
    }
    
}

class travelModel: NSObject,travelDataModel{

    
    static let sharedInstance = travelModel()
    
    private var users = [User]()
    public var tempUser:User
    public var loggin:Bool
    var filepath:String
    
    override init() {
        filepath = ""
        loggin = false

        tempUser = User(username: "temp", password: "temp")
        let manager = FileManager.default
        if let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
                   filepath = url.appendingPathComponent("users.plist").path
                   print("filepath=\(filepath)")
               }
        // read from the plist file if it exists
         if manager.fileExists(atPath: filepath) {
            print ("find the path")
             if let userArray = NSArray(contentsOfFile: filepath) {
                 for dict in userArray {
                     // converting from NSString to String
                    let userDict = dict as! [String: String]
                    if let usernameString = userDict["username"], let passwordString = userDict["password"] {
                    print (usernameString)
                    let u = User(username: usernameString, password: passwordString)
                    users.append(u)
                    }
                 }
             }
         } else {
             // fill with data
            let user1 = User(username: "Emma", password: "emmapassword")
            let user2 = User(username: "Jack", password: "jackpassword")
            let user3 = User(username: "Kathrine", password: "katherinepassword")
            let user4 = User(username: "Ashly", password: "ashlypassword")
            let user5 = User(username: "Frank", password: "frankpassword")

             users = [user1, user2, user3, user4,user5]
         }
    }
    
    // return true for finding repeated users
    func checkRepeatUsername(username:String)->Bool{
        for u in users{
            if u.getUsername() == username{
                return true
            }
        }
        print ("inside check repeat")
        save()
        return false
    }

    // return true for verified
    func verify(username:String, password:String)->Bool{
        print ("inside verify")
        for u in users{
            if u.getUsername() == username{
                if u.getPassword() == password{
                    loggin = true
                    return true
                }
            }
        }
        save()
        return false
    }
    
    
    func findUser(username:String)->Void{
        print ("inside finduser")
        for u in users{
            if u.getUsername() == username{
                tempUser = u
            }
        }
        save()
    }

     func save(){
        var userArray = [[String:String]]()
        print ("saving here")
        // loop thru array of Quotes and put into quotesArray
        for user in users {
            let u = ["username": user.getUsername(),
                     "password": user.getPassword()]
            
            userArray.append(u)
            print (user.getUsername())
        }
        // write to the file system
        (userArray as NSArray).write(toFile: filepath, atomically: true)

    }
}
