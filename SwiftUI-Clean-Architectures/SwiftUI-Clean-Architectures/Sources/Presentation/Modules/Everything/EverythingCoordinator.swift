//
//  EverythingCoordinator.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import SwiftUI

struct EverythingCoordinator: View {
    enum Screen: Hashable {
        case detail(Article)
    }
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            rootView()
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .detail(let article):
                        EverythingDetailScreen(viewModel: AnyViewModel(EverythingDetailViewModel(article: article)))
                    }
                }
        }
    }
    
    
    @ViewBuilder
    func rootView() -> some View {
        let viewModel = EverythingViewModel(onShowingDetail: showDetail)
        EverythingScreen(viewModel: AnyViewModel(viewModel))
    }
    
    func showDetail(_ article: Article) {
        path.append(Screen.detail(article))
    }
}
