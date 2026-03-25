//
//  WorkoutRecord.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import Foundation
import SwiftData

// MARK: - SwiftData modeli (kalıcı kayıt)
@Model
final class WorkoutRecord {
    var id: UUID
    var exerciseType: String
    var repCount: Int
    var duration: TimeInterval
    var averageConfidence: Double
    var date: Date
    
    init(from session: ExerciseSession) {
        self.id = session.id
        self.exerciseType = session.exerciseType.rawValue
        self.repCount = session.repCount
        self.duration = session.duration
        self.averageConfidence = session.averageConfidence
        self.date = session.startDate
    }
    
    // Hesaplanan özellikler
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    var exerciseTypeEnum: ExerciseType {
        ExerciseType(rawValue: exerciseType) ?? .squat
    }
}
