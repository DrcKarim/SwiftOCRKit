//
//  VisionFaceDetection.swift
//  SwiftVisionKit
//
//  Created by Karim Bouchaane on 07/02/2026.
//

import Vision

public enum VisionFaceDetection {

    /// Detects faces in a CGImage using Apple Vision.
    public static func detectFaces(from cgImage: CGImage) async throws -> [DetectedFace] {
        try await withCheckedThrowingContinuation { continuation in

            let request = VNDetectFaceRectanglesRequest { request, error in
                if let error {
                    continuation.resume(
                        throwing: VisionFaceDetectionError.visionError(error)
                    )
                    return
                }

                let observations = request.results as? [VNFaceObservation] ?? []

                let faces = observations.map {
                    DetectedFace(boundingBox: $0.boundingBox)
                }

                continuation.resume(returning: faces)
            }

            let handler = VNImageRequestHandler(cgImage: cgImage)

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(
                    throwing: VisionFaceDetectionError.visionError(error)
                )
            }
        }
    }

}
