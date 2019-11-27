//
//  Member.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class Member: Codable {
    let id: String
    let name: name
    let age: Int
    let email: String
    let phone: String
    
    var fullName: String {
        return "\(self.name.first) \(self.name.last)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id         = "_id"
        case age, name, email, phone
    }
    
    class name: Codable {
        let first: String
        let last: String
    }
}
