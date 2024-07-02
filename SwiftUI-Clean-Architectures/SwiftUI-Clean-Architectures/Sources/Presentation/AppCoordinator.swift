//
//  AppCoordinator.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import SwiftUI

struct AppCoordinator: View {
    var body: some View {
        TabView {
            EverythingCoordinator()
                .tabItem { Label("Everything", systemImage: "star.circle") }
            HeadlineCoordinator()
                .tabItem { Label("TopHeadlines", systemImage: "globe") }
        }
    }
}
