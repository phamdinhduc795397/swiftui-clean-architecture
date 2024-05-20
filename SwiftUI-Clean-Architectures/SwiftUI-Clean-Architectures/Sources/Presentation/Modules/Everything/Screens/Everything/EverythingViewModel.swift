//
//  EverythingViewModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import CombineExt
import Stinsen
import Combine
import Factory

struct EverythingState {
    var keyword: String = ""
    var articles: [Article] = []
}

enum EverythingInput {
    case fetchData
    case showDetail(Article)
}

class EverythingViewModel: ViewModel {
    
    @Published
    var state: EverythingState = .init()
    
    let fetchDataStream = PassthroughRelay<Void>()
    private var cancellables = Set<AnyCancellable>()
    
    @RouterObject
    var router: EverythingCoordinator.Router?
    
    @Injected(\.fetchEverythingUseCase)
    var fetchEverythingUseCase
    
    init() {
        initData()
    }
    
    func initData() {
        let fetchingArticles = fetchDataStream
            .prefix(1)
            .withUnretained(self)
            .flatMap { base, _ in
                base.fetchEverything(keyword: "Apple")
            }
        
        let searchingArticles = $state
            .map(\.keyword)
            .removeDuplicates()
            .dropFirst()
            .withUnretained(self)
            .flatMap { base, keyword in
                base.fetchEverything(keyword: keyword)
            }
        
        Publishers.Merge(fetchingArticles, searchingArticles)
            .assign(to: \.state.articles, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    private func fetchEverything(keyword: String) -> AnyPublisher<[Article], Never> {
        fetchEverythingUseCase
            .execute(.init(keyword: keyword, page: 1, pageSize: 20))
            .map { $0.articles }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func trigger(_ input: EverythingInput) {
        switch input {
        case .fetchData:
            fetchDataStream.accept()
        case .showDetail(let article):
            router?.route(to: \.detail, article)
        }
    }
}
