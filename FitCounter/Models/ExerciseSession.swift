//
//  ExerciseSession.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import Foundation

// MARK: - Egzersiz türleri
enum ExerciseType: String, CaseIterable, Codable {
    case squat    = "Squat"
    case pushUp   = "Push Up"
    case sitUp    = "Sit Up"
    
    var icon: String {
        switch self {
        case .squat:  return "figure.strengthtraining.traditional"
        case .pushUp: return "figure.core.training"
        case .sitUp:  return "figure.flexibility"
        }
    }
}

// MARK: - Tek bir tekrar
struct Rep: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let confidence: Double   // CoreML'den gelecek (0.0 - 1.0)
    
    init(confidence: Double) {
        self.id = UUID()
        self.timestamp = Date()
        self.confidence = confidence
    }
}

// MARK: - Egzersiz seansı
struct ExerciseSession: Identifiable, Codable {
    let id: UUID
    let exerciseType: ExerciseType
    let startDate: Date
    var endDate: Date?
    var reps: [Rep]
    
    // Hesaplanan özellikler
    var repCount: Int { reps.count }
    
    var duration: TimeInterval {
        let end = endDate ?? Date()
        return end.timeIntervalSince(startDate)
    }
    
    var averageConfidence: Double {
        guard !reps.isEmpty else { return 0 }
        return reps.map(\.confidence).reduce(0, +) / Double(reps.count)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Init
    init(exerciseType: ExerciseType) {
        self.id = UUID()
        self.exerciseType = exerciseType
        self.startDate = Date()
        self.reps = []
    }
    
    // MARK: - Mutating
    mutating func addRep(confidence: Double) {
        reps.append(Rep(confidence: confidence))
    }
    
    mutating func finish() {
        endDate = Date()
    }
}
