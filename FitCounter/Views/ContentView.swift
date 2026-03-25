//
//  ContentView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var showExerciseSelection = false
    
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
                
                // MARK: - Üst bar
                VStack {
                    HStack {
                        Spacer()
                        
                        // Egzersiz seçim butonu (antrenman aktif değilse)
                        if !viewModel.isWorkoutActive {
                            Button {
                                showExerciseSelection = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: viewModel.selectedExercise.icon)
                                    Text(viewModel.selectedExercise.rawValue)
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 11))
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(.white.opacity(0.2), in: Capsule())
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                }
                
                // MARK: - UI
                RepCounterView(
                    repCount: viewModel.repCount,
                    exerciseType: viewModel.selectedExercise,
                    formattedTime: viewModel.formattedTime,
                    isActive: viewModel.isWorkoutActive,
                    onStart: { viewModel.startWorkout() },
                    onStop: { viewModel.stopWorkout() },
                    onReset: { viewModel.resetWorkout() },
                    onAddRep: { viewModel.addRep(confidence: 1.0) }
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
        .sheet(isPresented: $showExerciseSelection) {
            ExerciseSelectionView(
                selectedExercise: $viewModel.selectedExercise,
                isPresented: $showExerciseSelection
            )
        }
    }
}

#Preview {
    ContentView()
}
