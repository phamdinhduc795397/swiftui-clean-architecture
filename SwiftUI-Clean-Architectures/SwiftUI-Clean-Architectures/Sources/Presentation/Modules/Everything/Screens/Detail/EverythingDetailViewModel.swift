//
//  EverythingDetailViewModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation

struct EverythingDetailState {
    var article: Article
}

class EverythingDetailViewModel: ViewModel {
    
    @Published
    var state: EverythingDetailState
    
    init(article: Article) {
        self.state = .init(article: article)
    }
    
    func trigger(_ input: Never) {}
}
