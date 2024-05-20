//
//  ArticlePagingModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation

struct ArticlePagingModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
}

extension ArticlePagingModel {
    func asDomain() -> ArticlePaging {
        .init(status: status, totalResults: totalResults, articles: articles.map { $0.asDomain() })
    }
}
