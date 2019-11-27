//
//  MemberViewModelTest.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ClubHouse

class MemberViewModelTest: XCTestCase {
    fileprivate var companies: [Company]!
    
    func loadData() {
        // mocking service call
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "data", ofType: "json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            companies =  try JSONDecoder().decode([Company].self, from: data)
        } catch {
            companies = []
        }
    }
    
    fileprivate var viewModel: MemberViewModelProtocol!
    fileprivate var mockService: MockClubService!
    fileprivate var mockStore: StoreProtocol!
    fileprivate var scheduler: TestScheduler!
    fileprivate var disposeBag: DisposeBag!
    
    override func setUp() {
        loadData()
        
        mockService = MockClubService()
        mockStore   = MockStore()
        viewModel   = MemberViewModel(companies[0])
        scheduler   = TestScheduler(initialClock: 0)
        disposeBag  = DisposeBag()
    }

    override func tearDown() {
        viewModel   = nil
        mockService = nil
        scheduler   = nil
        disposeBag  = nil
    }
    
    func test_initialization() {
        let expectedCompany = companies[0]
        XCTAssertEqual(viewModel.query.value.isEmpty, true)
        XCTAssertEqual(viewModel.sortBy.value, SortOptions.none)
        XCTAssertEqual(viewModel.member(at: 0), expectedCompany.members?[0])
        XCTAssertEqual(viewModel.title.value, expectedCompany.name)
        
        var onNextCalled = 0
        var onErrorCalled = 0
        var onCompletedCalled = 0
        var onDisposedCalled = 0
        
        viewModel.title
            .subscribe(onNext: { n in
                    onNextCalled += 1
                }, onError: { e in
                    onErrorCalled += 1
                }, onCompleted: {
                    onCompletedCalled += 1
                }, onDisposed: {
                    onDisposedCalled += 1
                })
            .disposed(by: disposeBag)
        
            XCTAssertTrue(onNextCalled == 1)
            XCTAssertTrue(onErrorCalled == 0)
            XCTAssertTrue(onCompletedCalled == 0)
            XCTAssertTrue(onDisposedCalled == 0)
    }
    
    func test_reloadData() {
        viewModel.query.accept("Z")
        viewModel.reloadData()
        
        let expectedCompany = companies[0]
        XCTAssertEqual(viewModel.query.value.isEmpty, true)
        XCTAssertEqual(viewModel.member(at: 0), expectedCompany.members?[0])
    }
    
    func test_filter() {
        let txt = "l"
        viewModel.query.accept(txt)
        
        XCTAssertEqual(viewModel.query.value.isEmpty, false)
        
        let expected = companies[0].members?.filter { $0.fullName.lowercased().contains(txt.lowercased()) }
        XCTAssertEqual(viewModel.member(at: 0), expected?[0])
    }
    
    func test_sortFeature() {
        let sortOption = SortOptions.ageDescending
        viewModel.sortBy.accept(sortOption)
        
        let expected = companies[0].members?.sorted(by: { $0.age > $1.age })
        XCTAssertEqual(viewModel.member(at: 0), expected?[0])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
