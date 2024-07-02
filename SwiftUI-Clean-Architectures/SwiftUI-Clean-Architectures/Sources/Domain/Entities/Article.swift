//
//  Article.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation

struct Article: Identifiable, Hashable, Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

