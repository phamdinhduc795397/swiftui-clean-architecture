//
//  NetworkService.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Combine
import CombineMoya
import Moya
import Foundation

protocol NetworkServiceType {
    func fetchEverything(keyword: String, page: Int, pageSize: Int) -> AnyPublisher<ArticlePagingModel, NetworkError>
    func fetchTopHeadlines(page: Int, pageSize: Int) -> AnyPublisher<ArticlePagingModel, NetworkError>
}

class NetworkService {
    lazy var configuration: URLSessionConfiguration = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 300
        return sessionConfig
    }()
    
    lazy var provider = MoyaProvider<APITarget>(
        session: .init(configuration: configuration),
        plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .formatRequestAscURL))
        ]
    )
    
    func request<T: Decodable>(_ target: APITarget) -> AnyPublisher<T, NetworkError> {
        return provider
            .requestPublisher(target)
            .tryMap { response in
                try self.handleResponse(response)
            }
            .mapError { error in
                return self.mapError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func handleResponse<T: Decodable>(_ response: Response) throws -> T {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: response.data)
            return data
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
    func handleError(_ response: Response) -> NetworkError {
        let networkError: NetworkError
        do {
            switch response.statusCode {
            case 400:
                let decoder = JSONDecoder()
                let error = try decoder.decode(ErrorResponseModel.self, from: response.data)
                networkError = .badRequest(error: error)
            case 401:
                let decoder = JSONDecoder()
                let error = try decoder.decode(ErrorResponseModel.self, from: response.data)
                networkError = .unauthorized(error: error)
            default:
                networkError = .invalidResponse
            }
        } catch {
            networkError = .invalidResponse
        }
        
        return networkError
    }
    
    func mapError(_ error: Error) -> NetworkError {
        guard let moyaError = error as? MoyaError else {
            return .unknown
        }
        switch moyaError {
        case let .underlying(_, response):
            if let response = response {
                return handleError(response)
            } else {
                return .invalidResponse
            }
        default:
            return .unknown
        }
    }
}

extension NetworkService: NetworkServiceType {
    func fetchEverything(keyword: String, page: Int, pageSize: Int) -> AnyPublisher<ArticlePagingModel, NetworkError> {
        request(.fetchEverything(keyword: keyword, page: page, pageSize: pageSize))
    }
    
    func fetchTopHeadlines(page: Int, pageSize: Int) -> AnyPublisher<ArticlePagingModel, NetworkError> {
        request(.fetchTopHeadlines(page: page, pageSize: pageSize))
    }
}
