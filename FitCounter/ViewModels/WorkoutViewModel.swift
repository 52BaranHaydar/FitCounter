//
//  WorkoutViewModel.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//
import Foundation
import Combine
import AVFoundation
import Vision

@MainActor
final class WorkoutViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var currentSession: ExerciseSession?
    @Published var selectedExercise: ExerciseType = .squat
    @Published var isWorkoutActive: Bool = false
    @Published var errorMessage: String?
    @Published var elapsedTime: TimeInterval = 0
    @Published var currentPose: DetectedPose?
    @Published var skeletonPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
    
    // MARK: - Computed
    var repCount: Int { currentSession?.repCount ?? 0 }
    var formattedTime: String { currentSession?.formattedDuration ?? "00:00" }
    
    // MARK: - Private
    private let cameraService: CameraService
    private let poseService: PoseDetectionService
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    // Rep sayma için durum
    private var lastAngle: Double?
    private var repState: RepState = .idle
    
    // MARK: - Init
    init(
        cameraService: CameraService = CameraService(),
        poseService: PoseDetectionService = PoseDetectionService()
    ) {
        self.cameraService = cameraService
        self.poseService = poseService
        bindCamera()
        bindPose()
    }
    
    // MARK: - Camera Binding
    private func bindCamera() {
        cameraService.$error
            .compactMap { $0?.errorDescription }
            .receive(on: RunLoop.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        cameraService.framePublisher
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { [weak self] sampleBuffer in
                self?.poseService.processFrame(sampleBuffer)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Pose Binding
    private func bindPose() {
        poseService.posePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] pose in
                guard let self else { return }
                self.currentPose = pose
                self.updateSkeletonPoints(from: pose)
                
                if self.isWorkoutActive, let pose {
                    self.analyzeMovement(pose)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Skeleton Points
    private func updateSkeletonPoints(from pose: DetectedPose?) {
        guard let pose else {
            skeletonPoints = [:]
            return
        }
        skeletonPoints = pose.joints.mapValues { $0.point }
    }
    
    // MARK: - Hareket Analizi
    private func analyzeMovement(_ pose: DetectedPose) {
        switch selectedExercise {
        case .squat:   analyzeSquat(pose)
        case .pushUp:  analyzePushUp(pose)
        case .sitUp:   analyzeSitUp(pose)
        }
    }
    
    // Squat: kalça-diz-ayak bileği açısı
    private func analyzeSquat(_ pose: DetectedPose) {
        guard let angle = pose.angle(
            first: .leftHip,
            middle: .leftKnee,
            last: .leftAnkle
        ) else { return }
        
        detectRep(angle: angle, downThreshold: 90, upThreshold: 160)
    }
    
    // Push-up: omuz-dirsek-bilek açısı
    private func analyzePushUp(_ pose: DetectedPose) {
        guard let angle = pose.angle(
            first: .leftShoulder,
            middle: .leftElbow,
            last: .leftWrist
        ) else { return }
        
        detectRep(angle: angle, downThreshold: 90, upThreshold: 160)
    }
    
    // Sit-up: omuz-kalça-diz açısı
    private func analyzeSitUp(_ pose: DetectedPose) {
        guard let angle = pose.angle(
            first: .leftShoulder,
            middle: .leftHip,
            last: .leftKnee
        ) else { return }
        
        detectRep(angle: angle, downThreshold: 60, upThreshold: 120)
    }
    
    // MARK: - Rep Tespiti (aşağı → yukarı = 1 tekrar)
    private func detectRep(angle: Double, downThreshold: Double, upThreshold: Double) {
        switch repState {
        case .idle:
            if angle < downThreshold {
                repState = .down
            }
        case .down:
            if angle > upThreshold {
                repState = .idle
                let confidence = calculateConfidence(angle: angle, threshold: upThreshold)
                Task { @MainActor in
                    self.addRep(confidence: confidence)
                }
            }
        }
    }
    
    private func calculateConfidence(angle: Double, threshold: Double) -> Double {
        let extra = angle - threshold
        return min(1.0, max(0.5, extra / 40.0))
    }
    
    // MARK: - Workout Controls
    func startWorkout() {
        currentSession = ExerciseSession(exerciseType: selectedExercise)
        isWorkoutActive = true
        repState = .idle
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
        repState = .idle
        skeletonPoints = [:]
    }
    
    func addRep(confidence: Double = 1.0) {
        currentSession?.addRep(confidence: confidence)
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

// MARK: - Rep State
private enum RepState {
    case idle
    case down
}
