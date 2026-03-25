//
//  WorkoutViewModel.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import Foundation
import Combine
import AVFoundation

@MainActor
final class WorkoutViewModel: ObservableObject {
    
    // MARK: - Published (View bunları dinler)
    @Published var currentSession: ExerciseSession?
    @Published var selectedExercise: ExerciseType = .squat
    @Published var isWorkoutActive: Bool = false
    @Published var errorMessage: String?
    @Published var elapsedTime: TimeInterval = 0
    
    // MARK: - Computed
    var repCount: Int { currentSession?.repCount ?? 0 }
    var formattedTime: String { currentSession?.formattedDuration ?? "00:00" }
    
    // MARK: - Private
    private let cameraService: CameraService
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Init
    init(cameraService: CameraService = CameraService()) {
        self.cameraService = cameraService
        bindCamera()
    }
    
    // MARK: - Bindings
    private func bindCamera() {
        // Kamera hata durumunu dinle
        cameraService.$error
            .compactMap { $0?.errorDescription }
            .receive(on: RunLoop.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        // Frame'leri dinle (ileride PoseDetectionService buraya bağlanacak)
        cameraService.framePublisher
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] sampleBuffer in
                self?.processFrame(sampleBuffer)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Workout Controls
    func startWorkout() {
        currentSession = ExerciseSession(exerciseType: selectedExercise)
        isWorkoutActive = true
        cameraService.start()
        startTimer()
    }
    
    func stopWorkout() {
        currentSession?.finish()
        isWorkoutActive = false
        cameraService.stop()
        stopTimer()
    }
    
    func resetWorkout() {
        stopWorkout()
        currentSession = nil
        elapsedTime = 0
        errorMessage = nil
    }
    
    // MARK: - Rep (ileride CoreML'den gelecek)
    func addRep(confidence: Double = 1.0) {
        currentSession?.addRep(confidence: confidence)
    }
    
    // MARK: - Frame Processing (Aşama 2'de Vision buraya)
    private func processFrame(_ sampleBuffer: CMSampleBuffer) {
        // PoseDetectionService burada çağrılacak
    }
    
    // MARK: - Timer
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let session = self.currentSession else { return }
                self.elapsedTime = session.duration
            }
    }
    
    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    // MARK: - Camera
    var previewLayer: AVCaptureVideoPreviewLayer {
        cameraService.previewLayer
    }
}
