//
//  ExerciseSelectionView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//
import SwiftUI

struct ExerciseSelectionView: View {
    
    @Binding var selectedExercise: ExerciseType
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    // MARK: - Başlık
                    VStack(spacing: 8) {
                        Text("Egzersiz Seç")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Saymak istediğin egzersizi seç")
                            .font(.system(size: 15))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.top, 12)
                    
                    // MARK: - Egzersiz kartları
                    VStack(spacing: 16) {
                        ForEach(ExerciseType.allCases, id: \.self) { exercise in
                            ExerciseCard(
                                exercise: exercise,
                                isSelected: selectedExercise == exercise
                            ) {
                                selectedExercise = exercise
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isPresented = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") {
                        isPresented = false
                    }
                    .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(.black)
        .presentationCornerRadius(24)
    }
}

// MARK: - Egzersiz Kartı
struct ExerciseCard: View {
    
    let exercise: ExerciseType
    let isSelected: Bool
    let onTap: () -> Void
    
    // Her egzersiz için açıklama
    private var description: String {
        switch exercise {
        case .squat:  return "Diz bükme hareketi · Bacak & kalça"
        case .pushUp: return "Şınav hareketi · Göğüs & kol"
        case .sitUp:  return "Mekik hareketi · Karın kası"
        }
    }
    
    // Her egzersiz için renk
    private var accentColor: Color {
        switch exercise {
        case .squat:  return .blue
        case .pushUp: return .green
        case .sitUp:  return .orange
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                
                // İkon
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(isSelected ? 0.3 : 0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: exercise.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(accentColor)
                }
                
                // Metin
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.5))
                }
                
                Spacer()
                
                // Seçili işareti
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(accentColor)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(isSelected ? 0.12 : 0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? accentColor.opacity(0.6) : .clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview("Egzersiz Seçimi") {
    ExerciseSelectionView(
        selectedExercise: .constant(.squat),
        isPresented: .constant(true)
    )
}

#Preview("Push Up Seçili") {
    ExerciseSelectionView(
        selectedExercise: .constant(.pushUp),
        isPresented: .constant(true)
    )
}
