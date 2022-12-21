//
//  SwiftConcurrencyApp.swift
//  SwiftConcurrency
//
//  Created by Daniel Berezhnoy on 12/20/22.
//

import SwiftUI

@main
struct SwiftConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationLink {
                    TaskView()
                } label: {
                    Text("Click Me 🥹")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
