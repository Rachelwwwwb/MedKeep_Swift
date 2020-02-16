
import Foundation
struct Record {
    public var date: String
    public var keywords: [String]
    public var userID: Int
//    public var recordText : String
//    public var recordJson : String
    init(date: String, keywords: [String], userID: Int) {
        self.date = date
        self.keywords = keywords
        self.userID = userID
        
    }
}
struct User:Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        let areEqual = lhs.first_name == rhs.first_name &&
            lhs.last_name == rhs.last_name && lhs.userID == rhs.userID
        return areEqual
    }
    
    private var first_name : String
    private var last_name : String
    private var userID : Int
    public var currentDate : String?
    public var historyRecords : [Record]
    public var currentIndex:Int
    
    func getFirstName() -> String {
        return first_name
    }
    func getLastName() -> String {
        return last_name
    }
    func getUserId() -> Int {
        return userID
    }
    mutating func addRecord(r: Record) -> Void {
        historyRecords.append(r)
    }
//    mutating func getRecordsAsString()
    init(first_name: String, last_name: String, userID: Int){
        self.first_name = first_name
        self.last_name = last_name
        self.userID = userID
        self.currentIndex = 0
        self.historyRecords = []
    }
    mutating func getCurrentRecord()->Record{
        if currentIndex >= 0 && currentIndex < historyRecords.count{
            return historyRecords[currentIndex]
        }
        else {
            return Record(date: "", keywords: [], userID: -1)
        }
    }
    
}

class travelModel: NSObject,travelDataModel{

    
    static let sharedInstance = travelModel()
    
    public var users = [User]()
    public var currentUser:User
    public var AudioFilePath: URL

    override init() {
        currentUser = User(first_name: "", last_name: "", userID: -1)
        AudioFilePath = URL(string: "http://httpbin.org/post")!
    }
    
    func getUsers() -> Void {
        print ("getting users right now")
        guard let resourceURL = URL(string:"http://35.202.219.171:5000/users") else {fatalError()}
        let dataTask = URLSession.shared.dataTask(with: resourceURL){data,_,_ in
            guard let jsonData = data else {
                return
            }
            do {
                print ("getting users right now")
                let decoder = JSONDecoder()
                
                let List = try decoder.decode([singleUser].self,from:jsonData)
                for i in List{
                    let a:Int? = Int(i.id)
                    if let b = a {
                        let temp = User(first_name: i.first_name, last_name: i.last_name, userID: b)
                        print (temp.getFirstName())
                        self.users.insert(temp, at: 0)
                    }
                    
                }
            } catch {
            }
        }
        dataTask.resume()
    }
    func save(rec: Record){
        var keywordsss = String()
        for a in rec.keywords{
            keywordsss.append(a)
        }
        let json: [String: Any] = ["content": "64BitAudio",
                                   "description": keywordsss,
                                   "user_id": rec.userID]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://35.202.219.171:5000/recording")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()

    }
}
