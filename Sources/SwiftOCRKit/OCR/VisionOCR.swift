//
//  VisionOCR.swift
//  SwiftOCRKit
//
//  Created by Karim Bouchaane on 06/02/2026.
//

import Vision

public enum VisionOCR {

    /// Recognize text from a CGImage with default configuration
    public static func recognizeText(from cgImage: CGImage) async throws -> String {
        try await recognizeText(from: cgImage, configuration: VisionOCRConfiguration())
    }
    
    /// Recognize text from a CGImage with custom configuration
    public static func recognizeText(
        from cgImage: CGImage,
        configuration: VisionOCRConfiguration
    ) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            var resumed = false
            
            let request = VNRecognizeTextRequest { request, error in
                guard !resumed else { return }
                resumed = true
                
                if let error = error {
                    continuation.resume(
                        throwing: VisionOCRError.visionError(error)
                    )
                    return
                }

                let observations = request.results as? [VNRecognizedTextObservation] ?? []
                let text = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")

                continuation.resume(returning: text)
            }

            request.recognitionLevel = configuration.recognitionLevel
            request.usesLanguageCorrection = configuration.usesLanguageCorrection
            request.minimumTextHeight = configuration.minimumTextHeight
            
            if !configuration.recognitionLanguages.isEmpty {
                request.recognitionLanguages = configuration.recognitionLanguages
            }

            let handler = VNImageRequestHandler(cgImage: cgImage)

            do {
                try handler.perform([request])
            } catch {
                guard !resumed else { return }
                resumed = true
                continuation.resume(
                    throwing: VisionOCRError.visionError(error)
                )
            }
        }
    }
}

#if canImport(UIKit)
import UIKit

public extension VisionOCR {
    /// Recognize text from a UIImage with default configuration
    static func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw VisionOCRError.invalidImage
        }
        return try await recognizeText(from: cgImage)
    }
    
    /// Recognize text from a UIImage with custom configuration
    static func recognizeText(
        from image: UIImage,
        configuration: VisionOCRConfiguration
    ) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw VisionOCRError.invalidImage
        }
        return try await recognizeText(from: cgImage, configuration: configuration)
    }
}
#endif

#if canImport(AppKit)
import AppKit

public extension VisionOCR {
    /// Recognize text from an NSImage with default configuration
    static func recognizeText(from image: NSImage) async throws -> String {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw VisionOCRError.invalidImage
        }
        return try await recognizeText(from: cgImage)
    }
    
    /// Recognize text from an NSImage with custom configuration
    static func recognizeText(
        from image: NSImage,
        configuration: VisionOCRConfiguration
    ) async throws -> String {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw VisionOCRError.invalidImage
        }
        return try await recognizeText(from: cgImage, configuration: configuration)
    }
}
#endif

