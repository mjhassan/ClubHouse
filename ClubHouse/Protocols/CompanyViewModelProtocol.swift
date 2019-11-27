//
//  CompanyViewModelProtocol.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol CompanyViewModelProtocol {
    var list: BehaviorRelay<[Company]> { get }
    var query: BehaviorRelay<String> { get }
    var sortBy: BehaviorRelay<SortOptions> { get set }
    var loading:PublishSubject<Bool> { get }
    var companyCount: Int { get }
    var error: PublishSubject<String> { get }
    var disposeBag: DisposeBag { get }
    
    init(service: ServiceProtocol, store: StoreProtocol)
    
    func fetchData(force: Bool)
    func company(at index: Int) -> Company?
}

extension CompanyViewModelProtocol {
    init() {
        self.init(service: ClubService.shared, store: Store.shared)
    }
    
    func fetchData() { fetchData(force: false) }
}
