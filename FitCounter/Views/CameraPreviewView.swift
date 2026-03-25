//
//  CameraPreviewView.swift
//  FitCounter
//
//  Created by Baran on 25.03.2026.
//

import SwiftUI
import AVFoundation

// MARK: - UIKit köprüsü
struct CameraPreviewView: UIViewRepresentable {
    
    let previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.backgroundColor = .black
        return view
    }
    
    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        uiView.setPreviewLayer(previewLayer)
    }
}

// MARK: - Preview UIView
final class PreviewUIView: UIView {
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        previewLayer?.removeFromSuperlayer()
        layer.frame = bounds
        layer.videoGravity = .resizeAspectFill
        self.layer.insertSublayer(layer, at: 0)
        previewLayer = layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}

// MARK: - Preview
#Preview {
    // Simulator'da gerçek kamera olmadığı için siyah ekran gösterir
    // Gerçek cihazda test et
    let session = AVCaptureSession()
    let layer = AVCaptureVideoPreviewLayer(session: session)
    return CameraPreviewView(previewLayer: layer)
        .ignoresSafeArea()
        .background(.black)
}
