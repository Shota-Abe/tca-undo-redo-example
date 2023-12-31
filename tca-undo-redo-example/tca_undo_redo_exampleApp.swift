//
//  tca_undo_redo_exampleApp.swift
//  tca-undo-redo-example
//
//  Created by 安部翔太 on 2023/06/20.
//

import SwiftUI
import ComposableArchitecture

@main
struct tca_undo_redo_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: .init(initialState: .init(count: 0), reducer: CounterFeature()))
        }
    }
}
