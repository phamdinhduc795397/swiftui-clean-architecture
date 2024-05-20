//
//  AnyViewModel.swift
//  SwiftUI-Clean-Architectures
//
//  Created by Duc Pham on 18/5/24.
//

import Foundation
import Combine

@dynamicMemberLookup
final class AnyViewModel<State, Input>: ViewModel {

    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private var wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void
    private let updateWrappedState: (State) -> Void
    
    var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }
    
    var state: State {
        get { wrappedState() }
        set { updateWrappedState(newValue) }
    }
    
    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    subscript<Value>(dynamicMember keyPath: WritableKeyPath<State, Value>) -> Value {
        get { state[keyPath: keyPath] }
        set { state[keyPath: keyPath] = newValue }
    }
    
    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        self.updateWrappedState = { viewModel.state = $0 }
        self.wrappedState = { viewModel.state }
        self.wrappedTrigger = viewModel.trigger
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
    }
}
