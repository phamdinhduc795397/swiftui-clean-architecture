//
//  APITarget.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation
import Moya

enum APITarget {
    case fetchEverything(keyword: String, page: Int, pageSize: Int)
    case fetchTopHeadlines(page: Int, pageSize: Int)
}

extension APITarget: TargetType, AccessTokenAuthorizable {
    var method: Moya.Method {
        .get
    }
    
    var headers: [String : String]? {
        ["X-Api-Key": "ac884c208ebf47638078a1699d905e3d"]
    }
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .fetchEverything:
            return "/everything"
        case .fetchTopHeadlines:
            return "/top-headlines"
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchEverything(keyword, page, pageSize):
            var parameters: [String: Any] = [
                "q": keyword,
                "page": page,
                "pageSize": pageSize
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .fetchTopHeadlines(page, pageSize):
            let parameters: [String: Any] = [
                "country": "us",
                "page": page,
                "pageSize": pageSize
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
