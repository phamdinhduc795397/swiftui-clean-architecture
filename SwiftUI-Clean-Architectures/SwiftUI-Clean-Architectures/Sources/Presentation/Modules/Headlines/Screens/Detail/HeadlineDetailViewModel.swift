//
//  HeadlineDetailViewModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation

struct HeadlineDetailState {
    var article: Article
}

class HeadlineDetailViewModel: ViewModel {
    
    @Published
    var state: HeadlineDetailState
    
    init(article: Article) {
        self.state = .init(article: article)
    }
    
    func trigger(_ input: Never) {}
}
