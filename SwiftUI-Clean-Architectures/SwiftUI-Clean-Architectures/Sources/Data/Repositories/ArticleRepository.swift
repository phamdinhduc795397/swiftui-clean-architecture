//
//  ArticleRepository.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Combine

struct ArticleRepository: ArticleRepositoryType {
    let networkService: NetworkServiceType
    
    func fetchEverything(keyword: String, page: Int, pageSize: Int) -> AnyPublisher<ArticlePaging, Error> {
        networkService
            .fetchEverything(keyword: keyword, page: page, pageSize: pageSize)
            .map { $0.asDomain() }
            .genericError()
    }
    
    func fetchTopHeadlines(page: Int, pageSize: Int) -> AnyPublisher<ArticlePaging, Error> {
        networkService
            .fetchTopHeadlines(page: page, pageSize: pageSize)
            .map { $0.asDomain() }
            .genericError()
    }
}
