//
//  CompanyViewControllerDelegate.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol CompanyViewControllerDelegate {
    func willStartFetchingData()
    func didFinishFetchingData()
    func didFailedWithError(_ description: String)
}

extension CompanyViewControllerDelegate {
    func willStartFetchingData() {}
    func didFailedWithError(_ description: String) {}
}
