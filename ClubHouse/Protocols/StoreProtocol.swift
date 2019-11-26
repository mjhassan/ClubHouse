//
//  StoreProtocol.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol StoreProtocol {
    static var shared: StoreProtocol { get }
    
    func isFavorite(_ id: String) -> Bool
    func setFavorite(_ id: String, favorite: Bool)
    func isFollowing(_ id: String) -> Bool
    func setFollowing(_ id: String, following: Bool)
    
    func clearAll()
}
