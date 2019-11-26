//
//  ClubService.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation

enum ClubAPI {
    case companies(source: String)
    
    private static var baseURL = URLComponents(string: "https://next.json-generator.com/api")
    
    var url: URL? {
        switch self {
        case .companies(let source):
            ClubAPI.baseURL?.path = "/json/get/\(source)"
            
            guard let _url = ClubAPI.baseURL?.url else { return nil }
            return _url
        }
    }
}

final class ClubService: ServiceProtocol {
    static var shared: ServiceProtocol = ClubService()
    
    typealias callbackClosure = (Result<[Company], CodableError>) -> Void
    
    func getCompanies(_ completion: @escaping callbackClosure) {
        let source = "Vk-LhK44U"
        guard let url = ClubAPI.companies(source: source).url else {
            completion(.failure(.invalidURL(source)))
            return
        }
        
        let newsRequest = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: newsRequest) { [weak self] (data, _, error) in
            guard error == nil, let data = data else {
                completion(.failure(.custom(error!.localizedDescription)))
                return
            }
            
            self?.decode(data, completion)
        }.resume()
    }
    
    private func decode(_ data: Data, _ completion: @escaping callbackClosure) {
        do {
            let companies =  try JSONDecoder().decode([Company].self, from: data)
            completion(.success(companies))
        } catch {
            completion(.failure(.custom(error.localizedDescription)))
        }
    }
}
