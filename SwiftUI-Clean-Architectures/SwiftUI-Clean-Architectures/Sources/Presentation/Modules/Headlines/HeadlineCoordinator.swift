//
//  HeadlineCoordinator.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Stinsen
import SwiftUI

final class HeadlineCoordinator: NavigationCoordinatable {
    let stack = Stinsen.NavigationStack<HeadlineCoordinator>(initial: \HeadlineCoordinator.topHeadlines)
    
    @Root
    var topHeadlines = makeTopHeadlines
    
    @Route(.push)
    var headlineDetail = makeHeadlineDetail
}

extension HeadlineCoordinator {

    func makeTopHeadlines() -> TopHeadlinesScreen {
        TopHeadlinesScreen(viewModel: AnyViewModel(TopHeadlinesViewModel()))
    }
    
    func makeHeadlineDetail(_ article: Article) -> HeadlineDetailScreen {
        HeadlineDetailScreen(viewModel: AnyViewModel(HeadlineDetailViewModel(article: article)))
    }
}
