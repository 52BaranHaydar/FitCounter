//
//  ContentView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = WorkoutViewModel()
    
    var body: some View {
        ZStack {
            // MARK: - Kamera arka plan
            CameraPreviewView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()
            
            // MARK: - Karartma
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // MARK: - UI Katmanı
            RepCounterView(
                repCount: viewModel.repCount,
                exerciseType: viewModel.selectedExercise,
                formattedTime: viewModel.formattedTime,
                isActive: viewModel.isWorkoutActive,
                onStart: { viewModel.startWorkout() },
                onStop: { viewModel.stopWorkout() },
                onReset: { viewModel.resetWorkout() }
            )
            
            // MARK: - Hata mesajı
            if let error = viewModel.errorMessage {
                VStack {
                    Text(error)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.red.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                .padding(.top, 60)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
