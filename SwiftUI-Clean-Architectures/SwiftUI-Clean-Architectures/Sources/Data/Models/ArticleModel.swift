//
//  ArticleModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation

struct ArticleModel: Codable {
    let source: SourceModel
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

extension ArticleModel {
    func asDomain() -> Article {
        .init(source: source.asDomain(),
              author: author,
              title: title,
              description: description,
              url: url,
              urlToImage: urlToImage,
              publishedAt: publishedAt,
              content: content)
    }
}
