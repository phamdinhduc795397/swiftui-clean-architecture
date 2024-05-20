//
//  ArticleCell.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import SwiftUI

struct ArticleCell: View {
    let article: Article
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text(article.title)
                    .font(.title3)
                Text(article.description ?? "")
                    .font(.caption)
            }
            AsyncImage(url: .init(string: article.urlToImage ?? "")) { phase in
                if let image = phase.image {
                    image.resizable()
                        .aspectRatio(1, contentMode: .fill)
                } else {
                    ProgressView()
                }
            }
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
        }
    }
}
