//
//  ClubHouseTests.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ClubHouse

class CompanyViewProtocolTests: XCTestCase {
    fileprivate var viewModel: CompanyViewModelProtocol!
    fileprivate var mockService: MockClubService!
    fileprivate var mockStore: StoreProtocol!
    fileprivate var scheduler: TestScheduler!
    fileprivate var disposeBag: DisposeBag!
    
    override func setUp() {
        mockService = MockClubService()
        mockStore   = MockStore()
        viewModel   = CompanyViewModel(service: mockService, store: mockStore)
        scheduler   = TestScheduler(initialClock: 0)
        disposeBag  = DisposeBag()
    }

    override func tearDown() {
        viewModel   = nil
        mockService = nil
        scheduler   = nil
        disposeBag  = nil
    }

    func test_initialViewModel() {
        XCTAssertEqual(viewModel.companyCount, 0, "Companies should be empty as no data is loaded.")
        XCTAssertEqual(viewModel.query.value.isEmpty, true, "Initial query text is empty.")
        XCTAssertEqual(viewModel.sortBy.value, SortOptions.none, "Initial sort is by none.")
        XCTAssertNil(viewModel.company(at: 0), "Company at zero should be nil.")
    }
    
    func test_dataFetching() {
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.companyCount, mockService.companies.count)
        XCTAssertEqual(viewModel.query.value.isEmpty, true)
        XCTAssertEqual(viewModel.company(at: 0), mockService.companies[0])
    }
    
    func test_filter() {
        viewModel.fetchData()
        
        let txt = "A"
        viewModel.query.accept(txt)
        
        XCTAssertEqual(viewModel.query.value.isEmpty, false)
        
        let expected = mockService.companies.filter { $0.name.lowercased().contains(txt.lowercased()) }
        XCTAssertEqual(viewModel.companyCount, expected.count)
        XCTAssertEqual(viewModel.company(at: 0), expected[0])
    }
    
    func test_sortFeature() {
        viewModel.fetchData()
        
        let sortOption = SortOptions.nameDescending
        viewModel.sortBy.accept(sortOption)
        
        let expected = mockService.companies.sorted(by: { $0.name > $1.name })
        XCTAssertEqual(viewModel.companyCount, expected.count)
        XCTAssertEqual(viewModel.company(at: 0), expected[0])
    }
    
    func test_failedDataFetching() {
        let mockError: CodableError = CodableError.custom("Test Error")
        mockService.mockError = mockError
        
        viewModel.error
            .subscribe(onNext: { msg in
                XCTAssertEqual(msg, mockError.errorDescription)
            }).disposed(by: disposeBag)
        
        viewModel.fetchData()
        
        XCTAssertEqual(viewModel.companyCount, 0)
        XCTAssertNil(viewModel.company(at: 0))
    }
    
    func test_progressIndicator() {
        var onNextCalled        = 0
        var onErrorCalled       = 0
        var onCompletedCalled   = 0
        
        viewModel.loading
            .subscribe(onNext: { l in
                onNextCalled += 1
            }, onError: { e in
                onErrorCalled += 1
            }, onCompleted: {
                onCompletedCalled += 1
            }).disposed(by: disposeBag)
        
        viewModel.fetchData()
        
        XCTAssertTrue(onNextCalled == 2)
        XCTAssertTrue(onErrorCalled == 0)
        XCTAssertTrue(onCompletedCalled == 0)
    }
}
