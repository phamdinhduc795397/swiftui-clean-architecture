//
//  TopHeadlinesViewModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import CombineExt
import Combine
import Factory

struct TopHeadlinesState {
    var articles: [Article] = []
}

enum TopHeadlinesInput {
    case fetchData
    case showDetail(Article)
}

class TopHeadlinesViewModel: ViewModel {
    
    @Published
    var state: TopHeadlinesState = .init()
    
    let fetchDataStream = PassthroughRelay<Void>()
    private var cancellables = Set<AnyCancellable>()
    
    @Injected(\.fetchTopHeadlinesUseCase)
    var fetchTopHeadlinesUseCase
    
    let onShowingDetail: (Article) -> Void
    
    init(onShowingDetail: @escaping (Article) -> Void) {
        self.onShowingDetail = onShowingDetail
        initData()
    }
    
    func initData() {
        let fetchingArticles = fetchDataStream
            .prefix(1)
            .withUnretained(self)
            .flatMap { base, _ in
                base.fetchTopHeadlines()
            }
        
        fetchingArticles
            .assign(to: \.state.articles, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    private func fetchTopHeadlines() -> AnyPublisher<[Article], Never> {
        fetchTopHeadlinesUseCase
            .execute(.init(page: 1, pageSize: 20))
            .map { $0.articles }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func trigger(_ input: TopHeadlinesInput) {
        switch input {
        case .fetchData:
            fetchDataStream.accept()
        case .showDetail(let article):
            onShowingDetail(article)
        }
    }
}
