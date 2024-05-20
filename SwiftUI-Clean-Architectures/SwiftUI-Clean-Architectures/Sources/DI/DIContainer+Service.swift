//
//  DIContainer.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Factory

extension Container {
    var networkService: Factory<NetworkServiceType> {
        Factory(self) { NetworkService() }.singleton
    }
}
