//
//  Store.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class Store: StoreProtocol {
    static var shared: StoreProtocol = Store()
    
    private let localStorage = UserDefaults.standard
    private let FAV_KEY: String = "Favorites"
    private let FOL_KEY: String = "FollowList"
    
    func isFavorite(_ id: String) -> Bool {
        return localStorage[FAV_KEY]?[id] ?? false
    }
    
    func setFavorite(_ id: String, favorite: Bool) {
        var favorites: [String: Bool] = localStorage[FAV_KEY] ?? [:]
        favorites[id] = favorite
        localStorage[FAV_KEY] = favorites
    }
    
    func isFollowing(_ id: String) -> Bool {
        return localStorage[FOL_KEY]?[id] ?? false
    }
    
    func setFollowing(_ id: String, following: Bool) {
        var followings: [String: Bool] = localStorage[FOL_KEY] ?? [:]
        followings[id] = following
        localStorage[FOL_KEY] = followings
    }
    
    func clearAll() {
        localStorage.clearAll()
    }
}
