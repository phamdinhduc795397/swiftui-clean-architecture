//
//  ArticleRepository.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Combine

protocol ArticleRepositoryType {
    func fetchEverything(keyword: String, page: Int, pageSize: Int) -> AnyPublisher<ArticlePaging, Error>
    func fetchTopHeadlines(page: Int, pageSize: Int) -> AnyPublisher<ArticlePaging, Error>
}
