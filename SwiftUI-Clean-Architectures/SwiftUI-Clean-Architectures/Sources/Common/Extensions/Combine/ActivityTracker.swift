//
//  ActivityTracker.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Foundation
import Combine

typealias ActivityTracker = CurrentValueSubject<Bool, Never>

extension Publisher {
    func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Self.Output, Self.Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        }, receiveCancel: {
            activityTracker.send(false)
        })
        .eraseToAnyPublisher()
    }
}
