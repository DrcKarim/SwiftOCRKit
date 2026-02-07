//
//  VisionOCRConfiguration.swift
//  SwiftOCRKit
//
//  Created by Karim Bouchaane on 07/02/2026.
//

import Vision

/// Configuration options for OCR text recognition
public struct VisionOCRConfiguration {
    /// Recognition accuracy level (.accurate or .fast)
    public var recognitionLevel: VNRequestTextRecognitionLevel
    
    /// Enable language correction for better accuracy
    public var usesLanguageCorrection: Bool
    
    /// Minimum confidence threshold (0.0 to 1.0). Text below this confidence is ignored.
    /// Default is 0.0 (no filtering)
    public var minimumTextHeight: Float
    
    /// Custom recognition languages (e.g., ["en-US", "fr-FR"])
    /// Leave empty to use automatic language detection
    public var recognitionLanguages: [String]

    public init(
        recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
        usesLanguageCorrection: Bool = true,
        minimumTextHeight: Float = 0.0,
        recognitionLanguages: [String] = []
    ) {
        self.recognitionLevel = recognitionLevel
        self.usesLanguageCorrection = usesLanguageCorrection
        self.minimumTextHeight = minimumTextHeight
        self.recognitionLanguages = recognitionLanguages
    }
}
