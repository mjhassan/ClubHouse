//
//  CompanyExtension.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import ClubHouse

extension Company: Equatable {
    public static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.id == rhs.id
    }
}
