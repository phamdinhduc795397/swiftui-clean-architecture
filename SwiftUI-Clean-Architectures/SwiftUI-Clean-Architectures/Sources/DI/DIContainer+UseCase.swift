//
//  DIContainer+UseCase.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Factory

extension Container {
    var fetchEverythingUseCase: Factory<FetchEverythingUseCase> {
        Factory(self) { FetchEverythingUseCase(repository: self.articleRepository()) }
    }
    
    var fetchTopHeadlinesUseCase: Factory<FetchTopHeadlinesUseCase> {
        Factory(self) { FetchTopHeadlinesUseCase(repository: self.articleRepository()) }
    }
}
