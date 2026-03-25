//
//  RepCounterView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import SwiftUI

struct RepCounterView: View {
    
    let repCount: Int
    let exerciseType: ExerciseType
    let formattedTime: String
    let isActive: Bool
    let onStart: () -> Void
    let onStop: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Egzersiz türü
            HStack(spacing: 8) {
                Image(systemName: exerciseType.icon)
                    .font(.system(size: 18, weight: .medium))
                Text(exerciseType.rawValue)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.8))
            .padding(.top, 20)
            
            Spacer()
            
            // MARK: - Rep sayacı
            VStack(spacing: 4) {
                Text("\(repCount)")
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.3), value: repCount)
                
                Text("tekrar")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            // MARK: - Süre
            Text(formattedTime)
                .font(.system(size: 22, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.top, 12)
            
            Spacer()
            
            // MARK: - Butonlar
            HStack(spacing: 16) {
                if isActive {
                    Button(action: onStop) {
                        Label("Durdur", systemImage: "stop.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.red.opacity(0.8), in: RoundedRectangle(cornerRadius: 16))
                    }
                } else {
                    Button(action: onReset) {
                        Label("Sıfırla", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button(action: onStart) {
                        Label("Başlat", systemImage: "play.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview
#Preview("Aktif değil") {
    ZStack {
        Color.black.ignoresSafeArea()
        RepCounterView(
            repCount: 0,
            exerciseType: .squat,
            formattedTime: "00:00",
            isActive: false,
            onStart: {},
            onStop: {},
            onReset: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Aktif - 12 tekrar") {
    ZStack {
        Color.black.ignoresSafeArea()
        RepCounterView(
            repCount: 12,
            exerciseType: .pushUp,
            formattedTime: "01:23",
            isActive: true,
            onStart: {},
            onStop: {},
            onReset: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Sit Up") {
    ZStack {
        Color.black.ignoresSafeArea()
        RepCounterView(
            repCount: 30,
            exerciseType: .sitUp,
            formattedTime: "03:45",
            isActive: false,
            onStart: {},
            onStop: {},
            onReset: {}
        )
    }
    .preferredColorScheme(.dark)
}
