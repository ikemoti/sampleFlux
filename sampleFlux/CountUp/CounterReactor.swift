//
//  CounterReactor.swift
//  sampleFlux
//
//  Created by Sousuke Ikemoto on 2021/01/01.
//

import Foundation
import ReactorKit
import RxSwift

class CounterViewReactor: Reactor {
    
    enum Action {
        case increase
        case decrease
    }
    
    struct State {
        var value: Int
        var isLoading: Bool
    }
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    let initialState: State
    
    init() {
        self.initialState = State(
            value: 0,
            isLoading: false
        )
    }
    // concat??
    // just
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .increase:
                return Observable.concat([
                    Observable.just(Mutation.setLoading(true)),
                    Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                    Observable.just(Mutation.setLoading(false)),
                ])
                
            case .decrease:
                return Observable.concat([
                    Observable.just(Mutation.setLoading(true)),
                    Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                    Observable.just(Mutation.setLoading(false)),
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            case .increaseValue:
                state.value += 1
            case .decreaseValue:
                state.value -= 1
            case let .setLoading(isLoading):
                state.isLoading = isLoading
        }
        return state
    }
}

