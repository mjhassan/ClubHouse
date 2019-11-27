//
//  MockStore.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import ClubHouse

class MockStore: StoreProtocol {
    static var shared: StoreProtocol = MockStore()
    
    func isFavorite(_ id: String) -> Bool {
        return false
    }
    
    func setFavorite(_ id: String, favorite: Bool) {
        
    }
    
    func isFollowing(_ id: String) -> Bool {
        return false
    }
    
    func setFollowing(_ id: String, following: Bool) {
        
    }
    
    func clearAll() {
        
    }
    
    
}
