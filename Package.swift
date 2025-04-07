// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Backdoor",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Backdoor",
            targets: ["Backdoor"]),
    ],
    dependencies: [
        // MARK: - Core Dependencies (Actually used in the codebase)
        
        // UI and Image handling
        .package(url: "https://github.com/kean/Nuke.git", from: "12.1.0"),        
        .package(url: "https://github.com/sparrowcode/AlertKit.git", from: "5.0.0"), 
        
        // Onboarding - IMPORTANT: Using original package for API compatibility
        .package(url: "https://github.com/khcrysalis/UIOnboarding-18.git", branch: "main"),
        
        // File and Archive Management
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.16"), 
        .package(url: "https://github.com/tsolomko/SWCompression.git", from: "4.8.0"),  
        .package(url: "https://github.com/tsolomko/BitByteData.git", from: "2.0.0"),    
        
        // Security and Cryptography
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.7.0"),
        
        // UI Enhancement
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.3.0"),
        
        // Networking and API
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        
        // Development & Code Generation
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "7.0.0"),
        
        // Natural Language Processing
        .package(url: "https://github.com/SimformSolutionsPvtLtd/SSNaturalLanguage.git", from: "1.0.0"),
        
        // Networking - Using stable versions less likely to conflict
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.62.0"),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", from: "1.19.0"),
        
        // MARK: - Modern Swift Features
        
        // Logging - Production-grade logging system
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
        
        // Swift standard library extensions
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
        
        // Simplified Vapor dependencies
        .package(url: "https://github.com/vapor/vapor.git", from: "4.83.1"),
    ],
    targets: [
        .target(
            name: "Backdoor",
            dependencies: [
                // Core dependencies - actively used in codebase
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "NukeExtensions", package: "Nuke"),
                .product(name: "NukeVideo", package: "Nuke"),
                .product(name: "UIOnboarding", package: "UIOnboarding-18"),
                .product(name: "AlertKit", package: "AlertKit"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
                .product(name: "SWCompression", package: "SWCompression"),
                .product(name: "BitByteData", package: "BitByteData"),
                
                // Server-side components (Simplified)
                .product(name: "Vapor", package: "vapor"),
                
                // Security and Cryptography
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                
                // UI Enhancement
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Lottie", package: "lottie-spm"),
                
                // Networking and API
                .product(name: "Moya", package: "Moya"),
                .product(name: "RswiftLibrary", package: "R.swift"),
                
                // Natural Language Processing
                .product(name: "SSNaturalLanguage", package: "SSNaturalLanguage"),
                
                // Networking (simplified)
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOTransportServices", package: "swift-nio-transport-services"),
                
                // Modern Swift features
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: ".",
            exclude: [
                // Project files
                "backdoor.xcodeproj",
                "backdoor.xcworkspace",
                
                // Documentation
                "FAQ.md",
                "CODE_OF_CONDUCT.md",
                
                // Tools and scripts
                "scripts",
                "Makefile",
                "Clean",
                "app-repo.json",
                "fix_license_headers.sh",
                "localization_changes.patch",
                
                // Mixed language source files - handled specially
                "Shared/Magic/openssl_tools.mm",
                "Shared/Magic/openssl_tools.hpp",
                "Shared/Magic/zsign",
                
                // Backup and temporary files
                ".project_backup"
            ],
            swiftSettings: [
                // Debug optimization settings
                .define("DEBUG", .when(configuration: .debug)),
                .unsafeFlags(["-Onone"], .when(configuration: .debug)),
                
                // Release optimization settings
                .define("RELEASE", .when(configuration: .release)),
                .unsafeFlags(["-O"], .when(configuration: .release))
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)