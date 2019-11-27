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
    private let store: StoreProtocol!
    
    private var companies: [Company] = []
    private var list: [Company] = []
    
    public var filter: String = "" {
        didSet {
            filterUser()
        }
    }
    
    public var sortBy: SortOptions = .none {
        didSet {
            filterUser()
        }
    }
    
    public var companyCount: Int {
        return list.count
    }
    
    required init(bind delegate: CompanyViewControllerDelegate?, service: ServiceProtocol, store: StoreProtocol) {
        self.delegate = delegate
        self.service = service
        self.store = store
    }
    
    func fetchData(force: Bool = false) {
        delegate?.willStartFetchingData()
        
        service.getCompanies(reload: force) { [weak self] result in
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
        
        if sortBy == .nameAscending {
            list.sort(by: { $0.name <= $1.name })
        } else if sortBy == .nameDescending {
            list.sort(by: { $0.name > $1.name })
        }
        
        self.delegate?.didFinishFetchingData()
    }
}
