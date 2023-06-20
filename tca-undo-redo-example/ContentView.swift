//
//  ContentView.swift
//  tca-undo-redo-example
//
//  Created by 安部翔太 on 2023/06/20.
//

import SwiftUI
import ComposableArchitecture

struct CounterFeature: ReducerProtocol {
    // #1
    struct State: Equatable {
        var count: Int
        var undoStack: [Action] = []
        var redoStack: [Action] = []
    }
    
    // #2
    enum Action: Equatable {
        case setCount(Int)
        case increment
        case decrement
        case increment2
        case decrement2
        case undo
        case redo
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setCount(count):
                state.count = count
            case .increment:
                // #3
                state.undoStack.append(.setCount(state.count))
                state.redoStack = []
                state.count += 1
            case .decrement:
                state.undoStack.append(.setCount(state.count))
                state.redoStack = []
                state.count -= 1
            case .increment2:
                state.undoStack.append(.setCount(state.count))
                state.redoStack = []
                state.count += 2
            case .decrement2:
                state.undoStack.append(.setCount(state.count))
                state.redoStack = []
                state.count -= 2
            case .undo:
                // #4
                guard let last = state.undoStack.popLast() else { return .none }
                state.redoStack.append(.setCount(state.count))
                return .task { last }
            case .redo:
                // #5
                guard let last = state.redoStack.popLast() else { return .none }
                state.undoStack.append(.setCount(state.count))
                return .task { last }
            }
            return .none
        }
    }
}

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(
            store,
            observe: { $0 }
        ) { viewStore in
            NavigationStack {
                VStack {
                    Text("\(viewStore.count)")
                        .font(.title)
                    HStack(spacing: 16) {
                        Button("-2") {
                            viewStore.send(.decrement2)
                        }
                        Button("-1") {
                            viewStore.send(.decrement)
                        }
                        Button("+1") {
                            viewStore.send(.increment)
                        }
                        Button("+2") {
                            viewStore.send(.increment2)
                        }
                    }
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                }
                .toolbar {
                    Button {
                        viewStore.send(.undo)
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .disabled(viewStore.undoStack.isEmpty)

                    Button {
                        viewStore.send(.redo)
                    } label: {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    .disabled(viewStore.redoStack.isEmpty)
                }
            }
        }
    }
}
