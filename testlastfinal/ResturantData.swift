//
//  ResturantData.swift
//  test
//
//  Created by Xi Weng on 2022-02-20.
//

import Foundation
struct ResturantData: Decodable{
    var address: Address?
    var borough: String?
    var cuisine: String?
    var grade: [Grades]?
    var name: String?
    var _id: String?
    
}

struct Address: Decodable {
    var building: String?
    var coord: [Double]?
    var street: String?
    var zipcode: String?
}

struct Grades: Decodable{
    var date: Date?
    var grade: String?
    var score: Double?
}


