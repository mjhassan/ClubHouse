//
//  ClubHouseTests.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
@testable import ClubHouse

class CompanyViewProtocolTests: XCTestCase {
    fileprivate var mockViewController: MockCompanyViewController!
    fileprivate var viewModel: CompanyViewModelProtocol!
    fileprivate var mockService: MockClubService!
    fileprivate var mockStore: StoreProtocol!
    
    override func setUp() {
        mockViewController  = MockCompanyViewController()
        mockService         = MockClubService()
        mockStore           = MockStore()
        viewModel           = CompanyViewModel(bind: mockViewController,
                                               service: mockService,
                                               store: mockStore)
    }

    override func tearDown() {
        mockViewController  = nil
        viewModel           = nil
        mockService         = nil
    }

    func testInitialViewModel() {
        XCTAssertEqual(viewModel.companyCount, 0, "Companies should be empty as no data is loaded.")
        XCTAssertEqual(viewModel.filter.isEmpty, true, "Initial filter is empty.")
        XCTAssertNil(viewModel.company(at: 0), "Company at zero should be nil.")
    }
    
    func testDataFetching() {
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.companyCount, mockService.companies.count)
        XCTAssertEqual(viewModel.filter.isEmpty, true)
        XCTAssertEqual(viewModel.company(at: 0), mockService.companies[0])
        
        XCTAssertTrue(mockViewController.calledWillStartFetchingData == 1, "Should invoke fetching start indicator for loading HUD")
        XCTAssertTrue(mockViewController.calledDidFinishFetchingData == 1, "Should update and refresh view.")
    }
    
    func testFailedDataFetching() {
        let mockError: CodableError = CodableError.custom("Test Error")
        mockService.mockError = mockError
        
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.companyCount, 0)
        XCTAssertNil(viewModel.company(at: 0))
        
        XCTAssertTrue(mockViewController.calledWillStartFetchingData == 1, "Should invoke fetching start indicator for loading HUD")
        XCTAssertTrue(mockViewController.calledDidFinishFetchingData == 0, "Should not update and refresh view.")
        XCTAssertTrue(mockViewController.calledDidFailedWithError, "Should invoke error passing delegate.")
        XCTAssertEqual(mockViewController.errorDescription, mockError.errorDescription)
    }
    
    func testDataSearchFilter() {
        let filter = "NO"
        
        viewModel.fetchData()
        
        let expectedCompanies = mockService.companies.filter { $0.name.lowercased().contains(filter.lowercased()) }
        
        viewModel.filter = filter
        
        XCTAssertTrue(mockViewController.calledDidFinishFetchingData == 2, "Should update and refresh view.")
        XCTAssertEqual(viewModel.companyCount, expectedCompanies.count)
        XCTAssertEqual(viewModel.company(at: 0), expectedCompanies[0])
    }
}
