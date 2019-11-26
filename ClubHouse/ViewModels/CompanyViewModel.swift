//
//  CompanyViewModel.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class CompanyViewModel: CompanyViewModelProtocol {
    
    private let delegate: CompanyViewControllerDelegate?
    private let service: ServiceProtocol!
    
    private var companies: [Company] = []
    private var list: [Company] = []
    
    var filter: String = "" {
        didSet {
            filterUser()
        }
    }
    
    public var companyCount: Int {
        return list.count
    }
    
    required init(bind delegate: CompanyViewControllerDelegate?, service: ServiceProtocol) {
        self.delegate = delegate
        self.service = service
    }
    
    func fetchData() {
        delegate?.willStartFetchingData()
        
        service.getCompanies { [weak self] result in
            switch result {
            case .success(let _companies):
                self?.companies = _companies
                self?.filter = ""
            case .failure(let err):
                self?.delegate?.didFailedWithError(err.errorDescription ?? "Unknown error occured")
            }
        }
    }
    
    func company(at index: Int) -> Company? {
        return (index >= 0 && index < companyCount) ? list[index]:nil
    }
    
    private func filterUser() {
        list.removeAll()
        list = filter.isEmpty ? companies:companies.filter { $0.name.lowercased().contains(filter.lowercased()) }
        
        self.delegate?.didFinishFetchingData()
    }
}
