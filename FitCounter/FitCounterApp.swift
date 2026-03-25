//
//  FitCounterApp.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import SwiftUI
import CoreData

@main
struct FitCounterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
