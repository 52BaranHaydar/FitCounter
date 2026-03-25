//
//  HistoryView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Query(sort: \WorkoutRecord.date, order: .reverse) private var records: [WorkoutRecord]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if records.isEmpty {
                    // MARK: - Boş durum
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 56))
                            .foregroundStyle(.white.opacity(0.2))
                        
                        Text("Henüz antrenman yok")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("İlk antrenmandan sonra\nburada görünecek")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.3))
                            .multilineTextAlignment(.center)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            
                            // MARK: - Özet kartı
                            SummaryCard(records: records)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                            
                            // MARK: - Antrenman listesi
                            ForEach(records) { record in
                                WorkoutRecordCard(record: record)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Geçmiş")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Kapat") { dismiss() }
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                if !records.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            deleteAll()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red.opacity(0.8))
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func deleteAll() {
        records.forEach { modelContext.delete($0) }
        try? modelContext.save()
    }
}

// MARK: - Özet Kartı
struct SummaryCard: View {
    
    let records: [WorkoutRecord]
    
    private var totalReps: Int { records.reduce(0) { $0 + $1.repCount } }
    private var totalSessions: Int { records.count }
    private var totalMinutes: Int { Int(records.reduce(0) { $0 + $1.duration }) / 60 }
    
    var body: some View {
        HStack(spacing: 0) {
            StatItem(value: "\(totalSessions)", label: "Antrenman")
            Divider().background(.white.opacity(0.2)).frame(height: 40)
            StatItem(value: "\(totalReps)", label: "Toplam Rep")
            Divider().background(.white.opacity(0.2)).frame(height: 40)
            StatItem(value: "\(totalMinutes)dk", label: "Süre")
        }
        .padding(.vertical, 16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Antrenman Kartı
struct WorkoutRecordCard: View {
    
    let record: WorkoutRecord
    
    private var accentColor: Color {
        switch record.exerciseTypeEnum {
        case .squat:  return .blue
        case .pushUp: return .green
        case .sitUp:  return .orange
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            
            // İkon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: record.exerciseTypeEnum.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(accentColor)
            }
            
            // Bilgi
            VStack(alignment: .leading, spacing: 4) {
                Text(record.exerciseTypeEnum.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Text(record.formattedDate)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.4))
            }
            
            Spacer()
            
            // İstatistikler
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(record.repCount) rep")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text(record.formattedDuration)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .padding(14)
        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Preview
#Preview("Geçmiş - Dolu") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WorkoutRecord.self, configurations: config)
    
    // Mock data
    let exercises: [ExerciseType] = [.squat, .pushUp, .sitUp, .squat, .pushUp]
    let reps = [15, 20, 12, 18, 25]
    
    for (i, exercise) in exercises.enumerated() {
        var session = ExerciseSession(exerciseType: exercise)
        for _ in 0..<reps[i] { session.addRep(confidence: 0.9) }
        session.finish()
        let record = WorkoutRecord(from: session)
        container.mainContext.insert(record)
    }
    
    return HistoryView()
        .modelContainer(container)
}

#Preview("Geçmiş - Boş") {
    HistoryView()
        .modelContainer(for: WorkoutRecord.self, inMemory: true)
}
