//
//  FetchEverythingUseCase.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Combine

struct FetchEverythingUseCase: PublisherUseCase {
    struct InputData {
        let keyword: String
        let page: Int
        let pageSize: Int
    }
    typealias Input = InputData
    
    typealias Output = ArticlePaging
    
    let repository: ArticleRepositoryType
    
    func execute(_ input: Input) -> AnyPublisher<Output, Error> {
        repository.fetchEverything(keyword: input.keyword, page: input.page, pageSize: input.pageSize)
    }
}
