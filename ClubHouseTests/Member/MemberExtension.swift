//
//  MemberExtension.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import ClubHouse

extension Member: Equatable {
    public static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}
