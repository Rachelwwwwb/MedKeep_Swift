//
//  places.swift
//  FinalProject
//
//  Created by 王文贝 on 2019/12/12.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//

import Foundation


struct placeResponse:Decodable{
    var results:[placeDetail]
}

struct placeDetail:Decodable {
    var title:String
}
