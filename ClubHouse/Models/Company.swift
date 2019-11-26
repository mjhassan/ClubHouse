//
//  Company.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

struct Company: Codable {
    let id: String
    let name: String
    let logo: String
    let website: URL?
    let description: String?
    let members: [Member]?
    
    var favorite: Bool = false
    var following: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id          = "_id"
        case name        = "company"
        case description = "about"
        case logo, website, members
    }
}
