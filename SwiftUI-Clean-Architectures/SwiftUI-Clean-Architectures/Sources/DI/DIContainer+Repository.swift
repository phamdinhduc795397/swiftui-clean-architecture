//
//  DIContainer+Repository.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Factory

extension Container {
    var articleRepository: Factory<ArticleRepositoryType> {
        Factory(self) { ArticleRepository(networkService: self.networkService()) }
    }
}
