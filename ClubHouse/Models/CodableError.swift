//
//  CodableError.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

enum CodableError: Error, LocalizedError {
    case unknown
    case invalidURL(String)
    case custom (String)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown error ccured", comment: "")
        case .invalidURL(let urlString):
            return NSLocalizedString("Invalid url for relative uri:\(urlString)", comment: "")
        case .custom(let context):
            return NSLocalizedString(context, comment: "")
        }
    }
}
