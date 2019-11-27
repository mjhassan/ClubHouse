//
//  MemberViewModel.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

class MemberViewModel: MemberViewModelProtocol {
    private let company: Company!
    
    private var members: [Member] = []
    private var list: [Member] = []
    
    public var dataUpdateClosure: (() -> Void)?
    public var title: String {
        return company.name
    }
    
    public var filter: String = "" {
        didSet {
            filterUser()
        }
    }
    
    public var memberCount: Int {
        return list.count
    }
    
    required init(_ company: Company) {
        self.company = company
        self.members = company.members ?? []
    }
    
    func reloadData() {
        filter = ""
    }
    
    func member(at index: Int) -> Member? {
        return (index >= 0 && index < memberCount) ? list[index]:nil
    }
    
    private func filterUser() {
        list.removeAll()
        list = filter.isEmpty ? members:members.filter { $0.fullName.lowercased().contains(filter.lowercased()) || String($0.age) == filter }
        
        invoke(onThread: DispatchQueue.main) { [weak self] in
            self?.dataUpdateClosure?()
        }
    }
}
