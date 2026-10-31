////
//  RationalLinearEquationSolver
//  BundleExtension
//
//  Created by LegoEsprit on 31.10.26.
//  Copyright (c) 2025 LegoEsprit
//

import Foundation

/// Usage: Bundle.main.displayName etc.
public extension Bundle {
    
    var displayName: String {
        infoDictionary?["CFBundleDisplayName"] as? String ?? "-"
    }
    /// Returns the app name
    var appName: String {
        infoDictionary?["CFBundleExecutable"] as? String ?? "..."
    }
    
    /// Returns the bundle id
    var bundleId: String {
        infoDictionary?["CFBundleIdentifier"] as? String ?? "..."
    }
    
    /// Returns the app version
    var build: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "..."
    }
    
    var version: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "..."
    }
    
    var copyright: String {
        infoDictionary?["NSHumanReadableCopyright"] as? String ?? "..."
    }


}
