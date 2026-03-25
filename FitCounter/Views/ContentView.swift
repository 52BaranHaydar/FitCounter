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
        GeometryReader { geo in
            ZStack {
                // MARK: - Kamera
                CameraPreviewView(previewLayer: viewModel.previewLayer)
                    .ignoresSafeArea()
                
                // MARK: - İskelet overlay
                SkeletonOverlayView(
                    joints: viewModel.skeletonPoints,
                    size: geo.size
                )
                .ignoresSafeArea()
                
                // MARK: - Karartma
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // MARK: - UI
                RepCounterView(
                    repCount: viewModel.repCount,
                    exerciseType: viewModel.selectedExercise,
                    formattedTime: viewModel.formattedTime,
                    isActive: viewModel.isWorkoutActive,
                    onStart: { viewModel.startWorkout() },
                    onStop: { viewModel.stopWorkout() },
                    onReset: { viewModel.resetWorkout() }
                )
                
                // MARK: - Hata
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
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
