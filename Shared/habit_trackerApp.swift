//
//  habit_trackerApp.swift
//  Shared
//

import SwiftUI

@main
struct habit_trackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
