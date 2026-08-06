////
//  RationalLinearEquationSolver
//  AboutView
//
//  Created by LegoEsprit on 25.07.26.
//  Copyright (c) 2025 LegoEsprit
//

import SwiftUI
import AppKit

/// Accessing bundle info
class BundleInfo {
    /// Returns the app name
    static var appName: String {
        infoDir?["CFBundleExecutable"] as? String ?? "..."
    }
    
    /// Returns the bundle id
    static var bundleId: String {
        infoDir?["CFBundleIdentifier"] as? String ?? "..."
    }
    
    /// Returns the app version
    static var bundleVersion: String {
        infoDir?["CFBundleVersion"] as? String ?? "..."
    }

    static var infoDir: [String : Any]? {
        let a = Bundle.main.infoDictionary
        return a
    }

}

/// View for a simple
struct AboutView: View {
    @State private var isShowingDialog = false
    var body: some View {
        VStack {
            HStack {
                Image(nsImage: NSImage(named: NSImage.applicationIconName) ?? NSImage())
                    .resizable()
                    .frame(width: 32, height: 32)
                Text(BundleInfo.appName)
            }
            Text(BundleInfo.bundleId).frame(width: 280)
            Text(BundleInfo.bundleVersion)
        }
        .frame(width: 350, height: 120)
    }
}

#Preview {
    AboutView()
}
