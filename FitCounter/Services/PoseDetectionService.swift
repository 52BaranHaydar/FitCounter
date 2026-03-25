//
//  PoseDetectionService.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import Vision
import AVFoundation
import Combine

// MARK: - Eklem noktası modeli
struct BodyJoint {
    let name: VNHumanBodyPoseObservation.JointName
    let point: CGPoint
    let confidence: Float
    
    var isReliable: Bool { confidence > 0.3 }
}

// MARK: - Tespit edilen poz
struct DetectedPose {
    let joints: [VNHumanBodyPoseObservation.JointName: BodyJoint]
    let timestamp: TimeInterval
    
    // Kolayca erişim
    func joint(_ name: VNHumanBodyPoseObservation.JointName) -> BodyJoint? {
        joints[name]
    }
    
    // Egzersiz açısı hesaplama için
    func angle(
        first: VNHumanBodyPoseObservation.JointName,
        middle: VNHumanBodyPoseObservation.JointName,
        last: VNHumanBodyPoseObservation.JointName
    ) -> Double? {
        guard
            let a = joint(first),  a.isReliable,
            let b = joint(middle), b.isReliable,
            let c = joint(last),   c.isReliable
        else { return nil }
        
        let ab = CGVector(dx: a.point.x - b.point.x, dy: a.point.y - b.point.y)
        let cb = CGVector(dx: c.point.x - b.point.x, dy: c.point.y - b.point.y)
        
        let dot    = ab.dx * cb.dx + ab.dy * cb.dy
        let magAB  = sqrt(ab.dx * ab.dx + ab.dy * ab.dy)
        let magCB  = sqrt(cb.dx * cb.dx + cb.dy * cb.dy)
        
        guard magAB > 0, magCB > 0 else { return nil }
        
        let cosAngle = max(-1, min(1, dot / (magAB * magCB)))
        return Double(acos(cosAngle)) * (180.0 / .pi)
    }
}

// MARK: - PoseDetectionService
final class PoseDetectionService {
    
    // Her frame'de tespit edilen pozu dışarı yayar
    let posePublisher = PassthroughSubject<DetectedPose?, Never>()
    
    private let requestHandler = VNSequenceRequestHandler()
    private var poseRequest: VNDetectHumanBodyPoseRequest?
    
    // MARK: - Init
    init() {
        setupRequest()
    }
    
    // MARK: - Setup
    private func setupRequest() {
        poseRequest = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard error == nil else {
                self?.posePublisher.send(nil)
                return
            }
            self?.processObservations(request.results)
        }
    }
    
    // MARK: - Frame işleme
    func processFrame(_ sampleBuffer: CMSampleBuffer) {
        guard let request = poseRequest else { return }
        
        do {
            try requestHandler.perform([request], on: sampleBuffer, orientation: .leftMirrored)
        } catch {
            posePublisher.send(nil)
        }
    }
    
    // MARK: - Gözlem işleme
    private func processObservations(_ results: [Any]?) {
        guard
            let observations = results as? [VNHumanBodyPoseObservation],
            let observation  = observations.first
        else {
            posePublisher.send(nil)
            return
        }
        
        var joints: [VNHumanBodyPoseObservation.JointName: BodyJoint] = [:]
        
        // Tüm eklem noktalarını al
        let jointNames: [VNHumanBodyPoseObservation.JointName] = [
            .nose,
            .leftEye, .rightEye,
            .leftEar, .rightEar,
            .leftShoulder, .rightShoulder,
            .leftElbow, .rightElbow,
            .leftWrist, .rightWrist,
            .leftHip, .rightHip,
            .leftKnee, .rightKnee,
            .leftAnkle, .rightAnkle,
            .root, .neck
        ]
        
        for name in jointNames {
            guard
                let point = try? observation.recognizedPoint(name),
                point.confidence > 0.1
            else { continue }
            
            joints[name] = BodyJoint(
                name: name,
                point: CGPoint(x: point.x, y: 1 - point.y), // Vision koordinatları ters
                confidence: point.confidence
            )
        }
        
        let pose = DetectedPose(joints: joints, timestamp: CACurrentMediaTime())
        posePublisher.send(pose)
    }
}
