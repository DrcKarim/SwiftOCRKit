//
//  VisionOCRError.swift
//  SwiftOCRKit
//
//  Created by Karim Bouchaane on 07/02/2026.
//

import Foundation

/// Errors that can occur during OCR text recognition
public enum VisionOCRError: Error, LocalizedError {
    /// The provided image could not be converted to CGImage
    case invalidImage
    
    /// No text was detected in the image
    case noTextFound
    
    /// An error occurred in the Vision framework
    case visionError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "The provided image is invalid or could not be processed"
        case .noTextFound:
            return "No text was detected in the image"
        case .visionError(let error):
            return "Vision framework error: \(error.localizedDescription)"
        }
    }
}
