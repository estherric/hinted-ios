//
//  HintedApp.swift
//  Hinted
//
//  Created by esther ricardo on 10/16/26.
//

import SwiftUI
import SwiftData

@main
struct HintedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // tells SwiftData which model our app needs to store and provide storage env
        .modelContainer(for: ClothingItem.self)
    }
}
