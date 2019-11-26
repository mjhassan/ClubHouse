//
//  ClubService.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import Foundation
import Haneke

enum ClubAPI {
    case companies(source: String)
    
    private static var baseURL = URLComponents(string: "https://next.json-generator.com")
    
    var url: URL? {
        switch self {
        case .companies(let source):
            ClubAPI.baseURL?.path = "/api/json/get/\(source)"
            
            guard let _url = ClubAPI.baseURL?.url else { return nil }
            return _url
        }
    }
}

final class ClubService: ServiceProtocol {
    static var shared: ServiceProtocol = ClubService()
    
    typealias callbackClosure = (Result<[Company], CodableError>) -> Void
    
    func getCompanies(reload: Bool, _ completion: @escaping callbackClosure) {
        let source = "Vk-LhK44U"
        guard let url = ClubAPI.companies(source: source).url else {
            completion(.failure(.invalidURL(source)))
            return
        }
        
        if reload {
            download(from: url, completion)
            return
        }
        
        Shared.dataCache.fetch(key: url.absoluteString)
            .onSuccess { [weak self] data in
                self?.decode(data, completion)
            }
            .onFailure { [weak self] _ in
                self?.download(from: url, completion)
            }
    }
    
    private func download(from url: URL, _ completion: @escaping callbackClosure) {
        let newsRequest = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: newsRequest) { [weak self] (data, _, error) in
            guard error == nil, let data = data else {
                completion(.failure(.custom(error!.localizedDescription)))
                return
            }
            
            self?.decode(data, completion)
            Shared.dataCache.set(value: data, key: url.absoluteString)
        }.resume()
    }
    
    private func decode(_ data: Data, _ completion: @escaping callbackClosure) {
        do {
            let companies =  try JSONDecoder().decode([Company].self, from: data)
            completion(.success(companies))
        } catch {
            #if DEBUG
            print(error)
            #endif
            
            completion(.failure(.custom(error.localizedDescription)))
        }
    }
}
