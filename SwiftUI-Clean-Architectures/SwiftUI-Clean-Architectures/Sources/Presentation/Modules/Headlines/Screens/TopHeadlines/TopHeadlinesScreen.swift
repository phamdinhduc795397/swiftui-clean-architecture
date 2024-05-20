//
//  TopHeadlinesScreen.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import SwiftUI

struct TopHeadlinesScreen: View {
    @ObservedObject var viewModel: AnyViewModel<TopHeadlinesState, TopHeadlinesInput>
    
    var body: some View {
        List {
            ForEach(viewModel.state.articles) { article in
                ArticleCell(article: article)
                    .onTapGesture {
                        viewModel.trigger(.showDetail(article))
                    }
            }
        }
        .onAppear {
            viewModel.trigger(.fetchData)
        }
    }
}

