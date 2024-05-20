//
//  EverythingCoordinator.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Stinsen
import SwiftUI

final class EverythingCoordinator: NavigationCoordinatable {
    let stack = Stinsen.NavigationStack<EverythingCoordinator>(initial: \EverythingCoordinator.home)

    @Root
    var home = makeEveything
    
    @Route(.push)
    var detail = makeEverythingDetail
}

extension EverythingCoordinator {
    func makeEveything() -> EverythingScreen {
        EverythingScreen(viewModel: AnyViewModel(EverythingViewModel()))
    }
    
    func makeEverythingDetail(_ article: Article) -> EverythingDetailScreen {
        EverythingDetailScreen(viewModel: AnyViewModel(EverythingDetailViewModel(article: article)))
    }
}
