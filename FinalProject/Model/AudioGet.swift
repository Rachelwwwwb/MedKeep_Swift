
import Foundation
import AVFoundation

struct AudioGet {
    
    init() {}
    
    func getData(){

let url = URL(string: "https://httpbin.org/get")!
let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let error = error {
        print("error: \(error)")
    } else {
        if let response = response as? HTTPURLResponse {
            print("statusCode: \(response.statusCode)")
        }
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("data: \(dataString)")
        }
    }
}
task.resume()
    }
}
