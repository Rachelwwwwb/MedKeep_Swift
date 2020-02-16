
import Foundation
import AVFoundation

struct AudioRequest{
    let userModel = travelModel.sharedInstance
    init(){
        
    }
    func postData()->([String]){
        var retwords = [String]()
        let headers = [
          "content-type": "application/json",
          "cache-control": "no-cache",
          "postman-token": "0001d4a0-a0e9-3a4e-6ef8-89a8a462c3d1"
        ]
        let file = Data(base64Encoded: userModel.AudioFilePath.path)
        do { let parameters = ["content":file] as [String : Any]
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: "http://35.202.240.173:5000/diarize")! as URL,cachePolicy:
            .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            guard let jsondata = data else {
                return
            }
            let httpResponse = response as? HTTPURLResponse
            do {
            let decoder = JSONDecoder()
            let audioResponseVar = try decoder.decode(audioResponse.self,from:jsondata)
                for i in audioResponseVar.results{
                    for j in i.wordsRequest.wordRequest{
                        retwords.insert(j.word, at: retwords.count)
                    }
                }
            } catch {
            }
            return
            }
        })
        dataTask.resume()

        } catch {
            print ("errors")
        }
        return retwords
        }
    
}
