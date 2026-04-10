//
//  Hydration_GameApp.swift
//  Hydration Game
//
//  Created by csuftitan on 3/26/26.
//

import SwiftUI
import SwiftData

@main
struct Hydration_GameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WaterData.self)
    }
}
