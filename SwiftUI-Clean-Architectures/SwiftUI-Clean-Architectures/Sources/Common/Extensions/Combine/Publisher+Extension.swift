//
//  Publisher+Extension.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 20/5/24.
//

import Combine

extension Publisher {
    func genericError() -> AnyPublisher<Self.Output, Error> {
        return mapError { $0 as Error }.eraseToAnyPublisher()
    }
    
    func unwrap<T>() -> AnyPublisher<T, Self.Failure> where Output == T? {
        return compactMap { $0 }.eraseToAnyPublisher()
    }
    
    func withUnretained<Root: AnyObject>(_ object: Root) -> AnyPublisher<(object: Root, value: Self.Output), Self.Failure> {
        let mapped = compactMap { [weak object] value -> (object: Root, value: Self.Output)? in
            guard let object = object else { return nil }
            return (object: object, value: value)
        }
        return mapped.eraseToAnyPublisher()
    }
    
    func mapToOptional() -> AnyPublisher<Output?, Failure> {
        map { $0 as Optional }.eraseToAnyPublisher()
    }
}
