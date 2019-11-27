//
//  CompanyViewModel.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class CompanyViewModel: CompanyViewModelProtocol {
    private let service: ServiceProtocol!
    private let store: StoreProtocol!
    
    private let companies: BehaviorRelay<[Company]> = BehaviorRelay(value: [])
    let list: BehaviorRelay<[Company]>              = BehaviorRelay(value: [])
    let query: BehaviorRelay<String>                = BehaviorRelay(value: "")
    var sortBy: BehaviorRelay<SortOptions>          = BehaviorRelay(value: .none)
    let loading:PublishSubject<Bool>                = PublishSubject<Bool>()
    let error: PublishSubject<String>               = PublishSubject<String>()
    let disposeBag                                  = DisposeBag()
    
    public var companyCount: Int {
        return list.value.count
    }
    
    required init(service: ServiceProtocol, store: StoreProtocol) {
        self.service = service
        self.store = store
        
        Observable.combineLatest(query, sortBy)
            .asObservable()
            .subscribe(onNext: { [weak self] (txt, sort)in
                self?.filterCompanies(txt, sort)
            }).disposed(by: disposeBag)
    }
    
    func fetchData(force: Bool = false) {
        loading.onNext(true)
        
        service.getCompanies(reload: force) { [weak self] result in
            guard let _ws = self else { return }
            
            _ws.loading.onNext(false)
            
            switch result {
            case .success(let _companies):
                _ws.companies.accept(_companies)
                _ws.query.accept("")
            case .failure(let err):
                _ws.error.onNext(err.errorDescription ?? "Unknown error occured")
            }
        }
    }
    
    func company(at index: Int) -> Company? {
        return (index >= 0 && index < companyCount) ? list.value[index]:nil
    }
    
    private func filterCompanies(_ txt: String = "", _ sort: SortOptions = .none) {
        var result = txt.isEmpty ? companies.value:companies.value.filter { $0.name.lowercased().contains(txt.lowercased()) }
        
        if sortBy.value == .nameAscending {
            result.sort(by: { $0.name <= $1.name })
        } else if sortBy.value == .nameDescending {
            result.sort(by: { $0.name > $1.name })
        }
        
        list.accept(result)
    }
}
