# SwiftVisionKit

**SwiftVisionKit** is a lightweight Swift package that provides clean, async/await wrappers around Apple Vision APIs for iOS and macOS.  
It focuses on developer experience by hiding Vision boilerplate and exposing simple, modern Swift APIs.

## Features

-  **On-device OCR** (text recognition)
-  **Async/await** based API
-  Supports **iOS** and **macOS**
-  Built on **Apple Vision**
-  **No network**, no backend, no data upload
-  Zero dependencies (other than Apple SDKs)

## Requirements

- **iOS** 15.0+
- **macOS** 12.0+
- **Swift** 5.7+

## Installation

### Swift Package Manager

Add SwiftVisionKit to your project using Swift Package Manager:

1. In Xcode, select **File → Add Packages...**
2. Enter the repository URL:
   ```
   https://github.com/DrcKarim/SwiftVisionKit
   ```
3. Select the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/DrcKarim/SwiftVisionKit", from: "1.0.0")
]
```

## Usage

### OCR from UIImage (iOS)

```swift
import SwiftVisionKit
import UIKit

let image = UIImage(named: "document")!
let text = try await VisionOCR.recognizeText(from: image)
print(text)
```

### OCR from NSImage (macOS)

```swift
import SwiftVisionKit
import AppKit

let image = NSImage(named: "document")!
let text = try await VisionOCR.recognizeText(from: image)
print(text)
```

### OCR from CGImage

```swift
import SwiftVisionKit

let cgImage: CGImage = // your CGImage
let text = try await VisionOCR.recognizeText(from: cgImage)
print(text)
```

## Configuration

You can customize OCR behavior using `VisionOCRConfiguration`:

```swift
let config = VisionOCRConfiguration(
    recognitionLevel: .accurate,  // or .fast
    usesLanguageCorrection: true
)

// Configuration support coming soon
let text = try await VisionOCR.recognizeText(
    from: image,
    configuration: config
)
```

### Available Options

- **`recognitionLevel`**: `.accurate` (default) or `.fast`
- **`usesLanguageCorrection`**: `true` (default) or `false`

## Error Handling

SwiftVisionKit exposes library-level errors for better control:

```swift
do {
    let text = try await VisionOCR.recognizeText(from: image)
    print(text)
} catch VisionOCRError.invalidImage {
    print("The provided image is invalid")
} catch VisionOCRError.noTextFound {
    print("No text was detected in the image")
} catch VisionOCRError.visionError(let error) {
    print("Vision framework error: \(error)")
} catch {
    print("Unexpected error: \(error)")
}
```

### Error Types

- **`VisionOCRError.invalidImage`**: The image could not be converted to CGImage
- **`VisionOCRError.noTextFound`**: No text was detected in the image
- **`VisionOCRError.visionError(Error)`**: Wrapper for underlying Vision framework errors

This keeps the API stable and predictable.

## Why SwiftVisionKit?

Apple Vision is powerful but verbose. SwiftVisionKit simplifies Vision usage into small, reusable, and testable APIs that feel natural in modern Swift codebases.

**Before (vanilla Vision):**
```swift
let request = VNRecognizeTextRequest { request, error in
    guard error == nil else { return }
    let observations = request.results as? [VNRecognizedTextObservation] ?? []
    let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
    // handle callback-based result...
}
request.recognitionLevel = .accurate
request.usesLanguageCorrection = true
let handler = VNImageRequestHandler(cgImage: cgImage)
try handler.perform([request])
```

**After (SwiftVisionKit):**
```swift
let text = try await VisionOCR.recognizeText(from: image)
```

## Roadmap

- [ ] Object detection
- [ ] Face detection and landmarks
- [ ] Barcode and QR code scanning
- [ ] PDF and batch image processing
- [ ] Custom language support for OCR
- [ ] Confidence scores for recognized text

## Contributing

Contributions are welcome! Please feel free to:

- Open an issue for bug reports or feature requests
- Submit a pull request with improvements
- Share feedback and suggestions

## License

MIT License

---

**Made with ❤️ by [Karim Bouchaane](https://github.com/DrcKarim)**
