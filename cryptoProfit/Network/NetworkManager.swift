//
//  NetworkManager.swift
//  cryptoProfit
//
//  Created by Musa Kokcen on 18.01.2021.
//

import Foundation
import Alamofire

public typealias Completion<T> = (Result<T, Error>) -> Void where T: Decodable

public class EmptyResponse: Codable {
    public init() {}
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    public init(sessionManager: Alamofire.Session = Alamofire.Session(configuration: URLSessionConfiguration.default)) {
        self.session = sessionManager
    }
    
    private var possibleEmptyBodyResponseCodes: Set<Int> {
        var defaultSet = DataResponseSerializer.defaultEmptyResponseCodes
        defaultSet.insert(200)
        defaultSet.insert(201)
        return defaultSet
    }
    
    private let session: Alamofire.Session
    public func request<T: Decodable>(type: T.Type, endpoint: Endpoint, completion: @escaping Completion<T>){
        session.request(endpoint.url,
                        method: endpoint.method,
                        parameters: endpoint.params,
                        encoding: URLEncoding.default)
            .validate()
            .response(responseSerializer: DataResponseSerializer(emptyResponseCodes: possibleEmptyBodyResponseCodes), completionHandler: { (response) in
                
                switch response.result {
                case .success(let data):
                    guard !data.isEmpty else {
                        completion(.success(EmptyResponse() as! T))
                        return
                    }
                    do {
                        let decodedObject = try JSONDecoder().decode(type, from: data)
                        completion(.success(decodedObject))
                    } catch let err {
                        completion(.failure(err))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}
