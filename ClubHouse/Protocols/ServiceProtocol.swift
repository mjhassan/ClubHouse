//
//  ServiceProtocol.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

protocol ServiceProtocol: class {
    static var shared: ServiceProtocol { get }
    func getCompanies(reload: Bool, _ completion: @escaping (Result<[Company], CodableError>) -> Void)
}

extension ServiceProtocol {
    func getCompanies(_ completion: @escaping (Result<[Company], CodableError>) -> Void) {
        getCompanies(reload: false, completion)
    }
}
