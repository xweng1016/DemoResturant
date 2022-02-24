//
//  ResturantData.swift
//  test
//
//  Created by Xi Weng on 2022-02-20.
//

import Foundation
struct ResturantData: Codable{
    var address: Address?
    var borough: String?
    var cuisine: String?
    var grades: [Grade]?
    var name: String?
    var _id: String?
    var restaurant_id: String?
    
}

struct Address: Codable {
    var building: String?
    var coord: [Double]?
    var street: String?
    var zipcode: String?
}

struct Grade: Codable{
    var date: String?
    var grade: String?
    var score: Double?
    var _id: String?
}


