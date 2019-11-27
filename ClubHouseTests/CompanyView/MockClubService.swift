//
//  MockClubService.swift
//  ClubHouseTests
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
@testable import ClubHouse

class MockClubService: ServiceProtocol {
    static var shared: ServiceProtocol = MockClubService()
    
    var companies: [Company] = []
    var mockError: CodableError? = nil
    
    func getCompanies(reload: Bool, _ completion: @escaping (Result<[Company], CodableError>) -> Void) {
        // for testing errors
        if mockError != nil {
            completion(.failure(mockError!))
            return
        }
        
        // mocking service call
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "data", ofType: "json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            companies =  try decoder.decode([Company].self, from: data)
            completion(.success(companies))
        } catch {
            completion(.failure(.custom(error.localizedDescription)))
        }
    }
}
