//
//  SortOptions.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

enum SortOptions: Int, CaseIterable {
    case none, nameAscending, nameDescending, ageAscending, ageDescending
    
    static var company: [SortOptions] {
        return [none, nameAscending, nameDescending]
    }
    
    static var member: [SortOptions] {
        return SortOptions.allCases
    }
    
    var caption: String {
        switch self {
        case .nameAscending:
            return "Name ↓"
        case .nameDescending:
            return "Name ↑"
        case .ageAscending:
            return "Age ↓"
        case .ageDescending:
            return "Age ↑"
        case .none:
            return "None"
        }
    }
}
