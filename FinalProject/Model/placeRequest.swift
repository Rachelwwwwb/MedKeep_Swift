//
//  placeRequest.swift
//  FinalProject
//
//  Created by 王文贝 on 2019/12/12.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//

import Foundation


struct placeRequest {
    
    enum placeError:Error{
        case noDataAvailable
        case canNotProcessData
    }
    let resourceURL:URL
    let API_KEY = "KRWNBdckCkUWBoaCylhMD0xaRXKKaE_bfpRqumqujZw"
    
    init (cityName:String){
        // change it to avoid space
        var city:String = cityName
        if let urlString = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            city = urlString.trimmingCharacters(in: .whitespaces)
        }

        let resourceString = "https://places.sit.ls.hereapi.com/places/v1/autosuggest?at=40.74917,-73.98529&q=\(city)&apikey=KRWNBdckCkUWBoaCylhMD0xaRXKKaE_bfpRqumqujZw"
        guard let resourceURL = URL(string:resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    func getPlaces()->[String]{
        var retval = [String]()
        let dataTask = URLSession.shared.dataTask(with: resourceURL){data,_,_ in
            guard let jsonData = data else {
                return
            }
            do {
                print ("here")
                let decoder = JSONDecoder()
//                print (jsonData)
                let placesResponse = try decoder.decode(placeResponse.self,from:jsonData)
//                print ("here")
                for i in placesResponse.results{
                    retval.insert(i.title, at: 0)
                    print(i.title)
                }
            } catch {
               return
            }
        }
        dataTask.resume()
        while retval.count == 0{
            sleep(1)
        }
        print ("amount : \(retval.count)")
        return retval
    }
    
    
}
