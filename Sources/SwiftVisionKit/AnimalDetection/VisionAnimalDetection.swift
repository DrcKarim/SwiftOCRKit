//
//  VisionObjectDetection.swift
//  SwiftVisionKit
//
//  Created by Karim Bouchaane on 07/02/2026.
//
import Vision

public enum VisionAnimalDetection {

    /// Detects animals (cats, dogs, etc.) using Apple Vision.
    public static func detectAnimals(
        from cgImage: CGImage
    ) async throws -> [DetectedAnimal] {

        try await withCheckedThrowingContinuation { continuation in

            let request = VNRecognizeAnimalsRequest { request, error in
                if let error = error {
                    continuation.resume(
                        throwing: VisionAnimalDetectionError.visionError(error)
                    )
                    return
                }

                let observations = request.results as? [VNRecognizedObjectObservation] ?? []

                if observations.isEmpty {
                    continuation.resume(
                        throwing: VisionAnimalDetectionError.noAnimalsFound
                    )
                    return
                }

                let animals: [DetectedAnimal] = observations.compactMap { observation in
                    guard let topLabel = observation.labels.first else {
                        return nil
                    }

                    return DetectedAnimal(
                        label: topLabel.identifier,
                        confidence: topLabel.confidence,
                        boundingBox: observation.boundingBox
                    )
                }

                continuation.resume(returning: animals)
            }

            let handler = VNImageRequestHandler(cgImage: cgImage)

            do {
                try handler.perform([request])
            } catch {
           //     continuation.resume(
            //        throwing: VisionAnimalDetectionError.visionError(error)
            //    )
                print("Vision animaldetection handler error: \(error)")
            }
        }
    }
}
