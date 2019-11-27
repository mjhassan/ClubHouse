//
//  MemberViewModelProtocol.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol MemberViewModelProtocol {
    var list: BehaviorRelay<[Member]> { get }
    var title: BehaviorRelay<String>  { get }
    var query: BehaviorRelay<String> { get }
    var sortBy: BehaviorRelay<SortOptions> { get set }
    var disposeBag: DisposeBag  { get }
    
    init(_ company: Company)
    
    func reloadData()
    func member(at index: Int) -> Member?
}
