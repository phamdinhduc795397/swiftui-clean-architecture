//
//  Application.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import SwiftUI

@main
struct Application: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator().view()
        }
    }
}
