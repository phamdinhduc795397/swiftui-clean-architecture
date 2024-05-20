//
//  EverythingDetailScreen.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import SwiftUI

struct EverythingDetailScreen: View {
    @ObservedObject var viewModel: AnyViewModel<EverythingDetailState, Never>

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if let urlToImage = viewModel.article.urlToImage {
                    AsyncImage(url: .init(string: urlToImage)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(1, contentMode: .fill)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                }
                Text(viewModel.article.title)
                    .font(.title)
            }
            Text(viewModel.article.content ?? "")
                .font(.body)
            Spacer()
        }
    }
}
