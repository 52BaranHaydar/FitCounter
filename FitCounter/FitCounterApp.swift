//
//  FitCounterApp.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//
import SwiftUI
import SwiftData

@main
struct FitCounterApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WorkoutRecord.self)
    }
}
