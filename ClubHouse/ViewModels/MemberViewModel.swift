//
//  MemberViewModel.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MemberViewModel: MemberViewModelProtocol {
    private let members: BehaviorRelay<[Member]> = BehaviorRelay(value: [])
    
    let list: BehaviorRelay<[Member]>      = BehaviorRelay(value: [])
    var title: BehaviorRelay<String>        = BehaviorRelay(value: "")
    let query: BehaviorRelay<String>        = BehaviorRelay(value: "")
    var sortBy: BehaviorRelay<SortOptions>  = BehaviorRelay(value: .none)
    var disposeBag: DisposeBag              = DisposeBag()
    
    private let company: Company!
    
    public var memberCount: Int {
        return list.value.count
    }
    
    required init(_ company: Company) {
        self.company = company
        self.members.accept(company.members ?? [])
        
        title.accept(company.name)
        
        Observable.combineLatest(query, sortBy)
            .asObservable()
            .subscribe(onNext: { [weak self] (txt, sort)in
                self?.filterMemebers(txt, sort)
            }).disposed(by: disposeBag)
    }
    
    func reloadData() {
        query.accept("")
    }
    
    func member(at index: Int) -> Member? {
        return (index >= 0 && index < memberCount) ? list.value[index]:nil
    }
    
    private func filterMemebers(_ txt: String = "", _ sort: SortOptions = .none) {
        var result = txt.isEmpty ? members.value :
            members.value.filter { $0.fullName.lowercased().contains(txt.lowercased())
                || String($0.age) == txt }
        
        switch sortBy.value {
        case .ageAscending:
            result.sort(by: { $0.age <= $1.age })
        case .ageDescending:
            result.sort(by: { $0.age > $1.age })
        case .nameAscending:
            result.sort(by: { $0.fullName <= $1.fullName })
        case .nameDescending:
            result.sort(by: { $0.fullName > $1.fullName })
        default:
            #if DEBUG
            print("Sort by: \(sortBy.value.caption)")
            #endif
        }
        
        list.accept(result)
    }
}
