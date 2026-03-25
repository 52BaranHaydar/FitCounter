//
//  SkeletonOverlayView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import SwiftUI
import Vision

struct SkeletonOverlayView: View {
    
    let joints: [VNHumanBodyPoseObservation.JointName: CGPoint]
    let size: CGSize
    
    // MARK: - Bağlantılar (hangi eklemler çizgiyle bağlanacak)
    private let connections: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
        // Gövde
        (.leftShoulder,  .rightShoulder),
        (.leftShoulder,  .leftHip),
        (.rightShoulder, .rightHip),
        (.leftHip,       .rightHip),
        // Sol kol
        (.leftShoulder,  .leftElbow),
        (.leftElbow,     .leftWrist),
        // Sağ kol
        (.rightShoulder, .rightElbow),
        (.rightElbow,    .rightWrist),
        // Sol bacak
        (.leftHip,       .leftKnee),
        (.leftKnee,      .leftAnkle),
        // Sağ bacak
        (.rightHip,      .rightKnee),
        (.rightKnee,     .rightAnkle),
        // Boyun
        (.neck,          .leftShoulder),
        (.neck,          .rightShoulder),
        (.neck,          .nose)
    ]
    
    var body: some View {
        Canvas { context, canvasSize in
            // Bağlantı çizgileri
            for (from, to) in connections {
                guard
                    let fromPoint = joints[from],
                    let toPoint   = joints[to]
                else { continue }
                
                var path = Path()
                path.move(to: convert(fromPoint, in: canvasSize))
                path.addLine(to: convert(toPoint, in: canvasSize))
                
                context.stroke(
                    path,
                    with: .color(.green.opacity(0.8)),
                    lineWidth: 2.5
                )
            }
            
            // Eklem noktaları
            for (name, point) in joints {
                let center = convert(point, in: canvasSize)
                let radius: CGFloat = isKeyJoint(name) ? 6 : 4
                let color: Color    = isKeyJoint(name) ? .yellow : .white
                
                let rect = CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )
                
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(color.opacity(0.9))
                )
            }
        }
    }
    
    // MARK: - Koordinat dönüşümü
    // Vision 0-1 normalize koordinatlarını ekran koordinatlarına çevirir
    private func convert(_ point: CGPoint, in canvasSize: CGSize) -> CGPoint {
        CGPoint(
            x: point.x * canvasSize.width,
            y: point.y * canvasSize.height
        )
    }
    
    // Egzersiz için kritik eklemler daha büyük gösterilir
    private func isKeyJoint(_ name: VNHumanBodyPoseObservation.JointName) -> Bool {
        [.leftKnee, .rightKnee,
         .leftHip,  .rightHip,
         .leftElbow,.rightElbow,
         .leftShoulder, .rightShoulder].contains(name)
    }
}

// MARK: - Preview
#Preview("İskelet - tam vücut") {
    let mockJoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [
        .nose:           CGPoint(x: 0.5,  y: 0.08),
        .neck:           CGPoint(x: 0.5,  y: 0.15),
        .leftShoulder:   CGPoint(x: 0.38, y: 0.22),
        .rightShoulder:  CGPoint(x: 0.62, y: 0.22),
        .leftElbow:      CGPoint(x: 0.28, y: 0.38),
        .rightElbow:     CGPoint(x: 0.72, y: 0.38),
        .leftWrist:      CGPoint(x: 0.22, y: 0.52),
        .rightWrist:     CGPoint(x: 0.78, y: 0.52),
        .leftHip:        CGPoint(x: 0.40, y: 0.55),
        .rightHip:       CGPoint(x: 0.60, y: 0.55),
        .leftKnee:       CGPoint(x: 0.38, y: 0.73),
        .rightKnee:      CGPoint(x: 0.62, y: 0.73),
        .leftAnkle:      CGPoint(x: 0.36, y: 0.90),
        .rightAnkle:     CGPoint(x: 0.64, y: 0.90)
    ]
    
    GeometryReader { geo in
        ZStack {
            Color.black
            SkeletonOverlayView(joints: mockJoints, size: geo.size)
        }
    }
    .ignoresSafeArea()
}

#Preview("İskelet - boş") {
    GeometryReader { geo in
        ZStack {
            Color.black
            SkeletonOverlayView(joints: [:], size: geo.size)
        }
    }
    .ignoresSafeArea()
}
