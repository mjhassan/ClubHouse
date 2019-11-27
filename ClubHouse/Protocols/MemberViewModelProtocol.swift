//
//  MemberViewModelProtocol.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol MemberViewModelProtocol {
    var title: String { get }
    var filter: String { get set }
    var memberCount: Int { get }
    var sortBy: SortOptions { get set }
    var dataUpdateClosure: (() -> Void)? { get set }
    
    init(_ company: Company)
    
    func reloadData()
    func member(at index: Int) -> Member?
}
