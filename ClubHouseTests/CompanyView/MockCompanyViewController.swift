//
//  MockCompanyViewController.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import ClubHouse

class MockCompanyViewController: CompanyViewControllerDelegate {
    public var calledWillStartFetchingData: Int = 0
    public var calledDidFinishFetchingData: Int = 0
    public var calledDidFailedWithError: Bool = false
    
    public var errorDescription: String? = nil
    
    func willStartFetchingData() {
        calledWillStartFetchingData += 1
    }
    
    func didFinishFetchingData() {
        calledDidFinishFetchingData += 1
    }
    
    func didFailedWithError(_ description: String) {
        errorDescription = description
        calledDidFailedWithError = true
    }
}
