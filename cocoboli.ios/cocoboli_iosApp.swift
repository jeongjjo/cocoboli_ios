//
//  cocoboli_iosApp.swift
//  cocoboli.ios
//
//  Created by cho.min-su on 2022/03/10.
//

import SwiftUI

@main
struct cocoboli_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Thread.sleep(forTimeInterval: 1.5)
                }
        }
    }
}
