//
//  AppCoordinator.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Stinsen
import SwiftUI

final class AppCoordinator: TabCoordinatable {
    var child = TabChild(
        startingItems: [
            \AppCoordinator.everything,
            \AppCoordinator.topHeadlines
        ]
    )
    
    @Route(tabItem: makeEverythingTabItem)
    var everything = makeEverything
    @Route(tabItem: makeTopHeadlinesTabItem)
    var topHeadlines = makeTopHeadlines
    
    @ViewBuilder
    func makeEverythingTabItem(isActive: Bool) -> some View {
        Label("Everything", systemImage: "star.circle")
    }
    
    @ViewBuilder
    func makeTopHeadlinesTabItem(isActive: Bool) -> some View {
        Label("TopHeadlines", systemImage: "globe")
    }
}

extension AppCoordinator {
    func makeEverything() -> NavigationViewCoordinator<EverythingCoordinator> {
        .init(EverythingCoordinator())
    }
    
    func makeTopHeadlines() -> NavigationViewCoordinator<HeadlineCoordinator> {
        .init(HeadlineCoordinator())
    }
}
