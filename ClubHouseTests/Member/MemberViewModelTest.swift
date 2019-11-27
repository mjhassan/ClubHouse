//
//  MemberViewModelTest.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import XCTest
@testable import ClubHouse

class MemberViewModelTest: XCTestCase {
    fileprivate var viewModel: MemberViewModelProtocol!
    fileprivate var companies: [Company]!
    
    override func setUp() {
        loadData()
        viewModel = MemberViewModel(companies[0])
    }

    override func tearDown() {
        viewModel = nil
    }

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
    
    func test_initialization() {
        let expectedCompany = companies[0]
        XCTAssertEqual(viewModel.title, expectedCompany.name)
        XCTAssertEqual(viewModel.filter.isEmpty, true)
        XCTAssertEqual(viewModel.memberCount, 0)
        XCTAssertNil(viewModel.dataUpdateClosure)
        XCTAssertNil(viewModel.member(at: 0))
    }
    
    func test_reloadData() {
        viewModel.reloadData()
        
        let expectedCompany = companies[0]
        XCTAssertEqual(viewModel.title, expectedCompany.name)
        XCTAssertEqual(viewModel.filter.isEmpty, true)
        XCTAssertEqual(viewModel.memberCount, expectedCompany.members?.count)
        XCTAssertNil(viewModel.dataUpdateClosure)
        XCTAssertEqual(viewModel.member(at: 0), expectedCompany.members?[0])
    }
    
    func test_nameFilter() {
        
        let search = "a"
        viewModel.filter = search
        let expectedMembers = companies[0].members?.filter { $0.fullName.lowercased().contains(search.lowercased()) }
        
        XCTAssertEqual(viewModel.filter.isEmpty, false)
        XCTAssertEqual(viewModel.memberCount, expectedMembers?.count)
        XCTAssertEqual(viewModel.member(at: 0), expectedMembers?[0])
    }

    func test_filter() {
        
        let search = "30"
        viewModel.filter = search
        let expectedMembers = companies[0].members?.filter { String($0.age) == search }
        
        XCTAssertEqual(viewModel.filter.isEmpty, false)
        XCTAssertEqual(viewModel.memberCount, expectedMembers?.count)
        XCTAssertEqual(viewModel.member(at: 0), expectedMembers?[0])
    }
    
    func test_dataUpdateClosure() {
        var dataUpdateClosureCalled: Int = 0
        
        viewModel.dataUpdateClosure = {
            dataUpdateClosureCalled += 1
        }
        
        XCTAssertNotNil(viewModel.dataUpdateClosure)
        XCTAssertEqual(viewModel.filter.isEmpty, true)
        
        viewModel.filter = "A"
        viewModel.reloadData()
        viewModel.filter = "b"
        
        let expected = expectation(description: String(#function))
        invoke(after: 5) {
            expected.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertEqual(dataUpdateClosureCalled, 3)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
