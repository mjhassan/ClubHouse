//
//  CompanyViewModelProtocol.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol CompanyViewModelProtocol {
    var companyCount: Int { get }
    var filter: String { get set }
    
    init(bind delegate: CompanyViewControllerDelegate?, service: ServiceProtocol)
    
    func fetchData()
    func company(at index: Int) -> Company?
}

extension CompanyViewModelProtocol {
    init(bind delegate: CompanyViewControllerDelegate?) {
        self.init(bind: delegate, service: ClubService.shared)
    }
}
